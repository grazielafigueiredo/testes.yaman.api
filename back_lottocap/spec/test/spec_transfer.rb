# frozen_string_literal: true

describe 'Realizar transferência com Bradesco/Itau/Santander/BBrasil e input/output exploratório' do
  CartDB.new.update_dataFinalVendaVigente('2020-12-25')
  @token = ApiUser.GetToken
  @login = ApiUser.Login(@token, Constant::User1)
  @idUsuario = @login.parsed_response['obj'][0]['idUsuario']
  TransferDB.new.delete_account(@idUsuario)
  TransferDB.new.insert_account(@idUsuario)

  context '[Bradesco] Realizar transferência com banco Bradesco' do
    before do
      @token = ApiUser.GetToken
      @login = ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @payment_transfer = build(:transfer_bradesco).to_hash
      @result = ApiTransfer.post_transfer(@token, @idCarrinho, @payment_transfer)
    end

    it 'Realizar transferência com banco Bradesco' do
      expect(JSON.parse(@result.response.body)['sucesso']).to be true
      expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Bradesco'
      expect(JSON.parse(@result.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 6
    end

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[Bradesco] Realizar transferência com uma conta já salva' do
    before do
      @token = ApiUser.GetToken
      @login = ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bradesco).to_hash
      @transfer[:transfAgencia] = '4242'
      @transfer[:transfConta] = '1120'
      @transfer[:transfContaDigito] = '0'
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end
    it { expect(JSON.parse(@payment_transfer.response.body)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  # context '[Bradesco] Tentar pagar com transferencia bancária um produto que esgotou as vendas, produto já reservado' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)
  #     CartDB.new.update_dataFinalVendaVigente(dataVincenda)

  #     @cart = build(:cart).to_hash
  #     @carrinho = ApiCart.post_add_item_cart(@token, @cart)
  #     @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

  #     Database.new.update_reservarSerie(1)
  #     @transfer = build(:transfer_bradesco).to_hash
  #     @result = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
  #     puts @carrinho
  #     puts @idCarrinho
  #     puts @result
  #   end

  #   it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Não foi possível Reservar os Titulos Solicitados!' }

  #   after do
  #     Database.new.update_reservarSerie(0)
  #     ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
  #     ApiUser.get_logout(@token)
  #   end
  # end

  #  # ----------------------Digito------------------------------

  context '[Bradesco] Input no campo ‘digito da conta’ com dados vazio' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bradesco).to_hash
      @transfer[:transfContaDigito] = ''
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it { expect(JSON.parse(@payment_transfer.response.body)['obj'][0]['digitoAgencia']).to eql '' }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[Bradesco] Input no campo ‘digito da conta’ acima de 1 casa decimal' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bradesco).to_hash
      @transfer[:transfContaDigito] = '23'
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it '[Bradesco] Input no campo ‘digito da conta’ acima de 1 casa decimal' do
      expect(@payment_transfer.response.code).to eql '400'
      expect(JSON.parse(@payment_transfer.response.body)['obj.transfContaDigito'][0]).to eql "The field transfContaDigito must be a string or array type with a maximum length of '1'."
    end

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  # ----------------------Nome Transferencia------------------------------

  context '[Bradesco] Input no campo ‘nome’ com dados vazio' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bradesco).to_hash
      @transfer[:nomeCompletoTitular] = ''
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it { expect(JSON.parse(@payment_transfer.response.body)['erros'][0]['mensagem']).to eql 'Bradesco: Agencia e Nome do Titular são obrigatórios' }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  # ----------------------Agencia Bancaria------------------------------

  context '[Bradesco] Input no campo ‘agência’ com menos de 4 casas decimais' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bradesco).to_hash
      @transfer[:transfAgencia] = '1'
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it { expect(JSON.parse(@payment_transfer.response.body)['sucesso']).to be true }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[Bradesco] Input no campo ‘agência’ com mais de 10 casas decimais' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bradesco).to_hash
      @transfer[:transfAgencia] = '23456789123'
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it 'Input no campo ‘agência’ com mais de 10 casas decimais' do
      expect(@payment_transfer.response.code).to eql '400'
      expect(JSON.parse(@payment_transfer.response.body)['obj.transfAgencia'][0]).to eql "The field transfAgencia must be a string or array type with a maximum length of '10'."
    end

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[Bradesco] Input no campo ‘agência’ com dados vazio' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bradesco).to_hash
      @transfer[:transfAgencia] = ''
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it { expect(JSON.parse(@payment_transfer.response.body)['erros'][0]['mensagem']).to eql 'Bradesco: Agencia e Nome do Titular são obrigatórios' }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  # ----------------------Conta Corrente------------------------------
  context '[Bradesco] Input no campo ‘conta corrente’ com mais de 10 casas decimais' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bradesco).to_hash
      @transfer[:transfConta] = '123456789123'
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it 'Input no campo ‘conta corrente’ com mais de 10 casas decimais' do
      expect(@payment_transfer.response.code).to eql '400'
      expect(JSON.parse(@payment_transfer.response.body)['obj.transfConta'][0]).to eql "The field transfConta must be a string or array type with a maximum length of '10'."
    end

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[Bradesco] Input no campo ‘conta corrente’ com menos de 4 casas decimais' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bradesco).to_hash
      @transfer[:transfConta] = '12'
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it { expect(JSON.parse(@payment_transfer.response.body)['sucesso']).to be true }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[Bradesco] Input no campo ‘conta corrente’ com dados vazio  ' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bradesco).to_hash
      @transfer[:transfConta] = ''
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it { expect(JSON.parse(@payment_transfer.response.body)['sucesso']).to be true }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[Itau] Realizar transferência com banco Itau' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_itau).to_hash
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it 'Realizar transferência com banco Itau' do
      expect(JSON.parse(@payment_transfer.response.body)['sucesso']).to be true
      expect(JSON.parse(@payment_transfer.response.body)['obj'][0]['nomeBanco']).to eql 'Itaú'
      expect(JSON.parse(@payment_transfer.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 7
    end

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[Itaú] Realizar transferência com uma conta já salva' do
    before do
      @token = ApiUser.GetToken
      @login = ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_itau).to_hash
      @transfer[:transfAgencia] = '4242'
      @transfer[:transfAgenciaDigito] = '4'
      @transfer[:transfConta] = '1120'
      @transfer[:transfContaDigito] = '7'
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end
    it { expect(JSON.parse(@payment_transfer.response.body)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[Santander] Realizar transferência com banco Santander' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_santander).to_hash
      @transfer[:cpf] = Faker::CPF.numeric
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it 'Realizar transferência com banco Santander' do
      expect(JSON.parse(@payment_transfer.response.body)['sucesso']).to be true
      expect(JSON.parse(@payment_transfer.response.body)['obj'][0]['nomeBanco']).to eql 'Banco Santander'
      expect(JSON.parse(@payment_transfer.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 8
    end

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[Santander] Realizar transferência com uma conta já salva' do
    before do
      @token = ApiUser.GetToken
      @login = ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_santander).to_hash
      @transfer[:cpf] = '66530420061'
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it { expect(JSON.parse(@payment_transfer.response.body)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[Santander] Input no campo ‘cpf’ com dados numéricos aleatórios' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_santander).to_hash
      @transfer[:cpf] = '12345678912'
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it { expect(JSON.parse(@payment_transfer.response.body)['sucesso']).to be true }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[BBrasil] Realizar transferência com Banco do Brasil' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bbrasil).to_hash
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it '[BBrasil] Realizar transferência com banco Brasil' do
      expect(JSON.parse(@payment_transfer.response.body)['sucesso']).to be true
      expect(JSON.parse(@payment_transfer.response.body)['obj'][0]['nomeBanco']).to eql 'Banco do Brasil'
      expect(JSON.parse(@payment_transfer.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 9
    end

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context '[BBrasil] Realizar transferência com uma conta já salva do Brasil' do
    before do
      @token = ApiUser.GetToken
      @login = ApiUser.Login(@token, Constant::User1)
      @idUsuario = @login.parsed_response['obj'][0]['idUsuario']

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bbrasil).to_hash
      @transfer[:transfAgencia] = '8080'
      @transfer[:transfAgenciaDigito] = '7'
      @transfer[:transfConta] = '5966'
      @transfer[:transfContaDigito] = '8'
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it { expect(JSON.parse(@payment_transfer.response.body)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end
end
