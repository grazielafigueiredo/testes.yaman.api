# frozen_string_literal: true

describe 'Realizar transferência com Bradesco/Itau/Santander/BBrasil e input/output exploratório' do
  context '[Bradesco] Realizar transferência com banco Bradesco' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']
      payment_transfer = build(:transfer_bradesco).to_hash
      @result = ApiTransfer.post_transfer(@token, idCarrinho, payment_transfer)
      # puts @result
    end

    it 'Realizar transferência com banco Bradesco' do
      expect((@result.parsed_response)['sucesso']).to be true
      expect((@result.parsed_response)['obj'][0]['nomeBanco']).to eql 'Bradesco'
      expect((@result.parsed_response)['obj'][0]['idTipoFormaPagamentoFeito']).to be 6
    end
  end

  context '[Bradesco] Realizar transferência com uma conta já salva' do
    before do
      TransferDB.new.delete_account(@idUsuario)
      TransferDB.new.insert_account(@idUsuario)

      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_bradesco).to_hash
      transfer[:transfAgencia] = '4242'
      transfer[:transfConta] = '1120'
      transfer[:transfContaDigito] = '0'
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end
    it { expect((@payment_transfer.parsed_response)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }
  end

  # context '[Bradesco] Tentar pagar com transferencia bancária um produto que esgotou as vendas, produto já reservado' do
  #   before do
  #     @cart = build(:cart).to_hash
  #     @carrinho = ApiCart.post_add_item_cart(@token, @cart)
  #     @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

  #     Database.new.update_reservarSerie(1)
  #     @transfer = build(:transfer_bradesco).to_hash
  #     @result = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)

  #   end

  #   it { expect((@result.parsed_response)['erros'][0]['mensagem']).to eql 'Não foi possível Reservar os Titulos Solicitados!' }

  #   after do
  #     Database.new.update_reservarSerie(0)
  #     ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
  #   end
  # end

  #  # ----------------------Digito------------------------------

  context '[Bradesco] Input no campo ‘digito da conta’ com dados vazio' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_bradesco).to_hash
      transfer[:transfContaDigito] = ''
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it { expect((@payment_transfer.parsed_response)['obj'][0]['digitoAgencia']).to eql '' }
  end

  context '[Bradesco] Input no campo ‘digito da conta’ acima de 1 casa decimal' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_bradesco).to_hash
      transfer[:transfContaDigito] = '23'
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it '[Bradesco] Input no campo ‘digito da conta’ acima de 1 casa decimal' do
      expect(@payment_transfer.response.code).to eql '400'
      expect((@payment_transfer.parsed_response)['obj.transfContaDigito'][0]).to eql "The field transfContaDigito must be a string or array type with a maximum length of '1'."
    end
  end

  # ----------------------Nome Transferencia------------------------------

  context '[Bradesco] Input no campo ‘nome’ com dados vazio' do
    before do
      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @transfer = build(:transfer_bradesco).to_hash
      @transfer[:nomeCompletoTitular] = ''
      @payment_transfer = ApiTransfer.post_transfer(@token, @idCarrinho, @transfer)
    end

    it { expect((@payment_transfer.parsed_response)['erros'][0]['mensagem']).to eql 'Bradesco: Agencia e Nome do Titular são obrigatórios' }
  end

  # ----------------------Agencia Bancaria------------------------------

  context '[Bradesco] Input no campo ‘agência’ com menos de 4 casas decimais' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_bradesco).to_hash
      transfer[:transfAgencia] = '1'
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it { expect((@payment_transfer.parsed_response)['sucesso']).to be true }
  end

  context '[Bradesco] Input no campo ‘agência’ com mais de 10 casas decimais' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_bradesco).to_hash
      transfer[:transfAgencia] = '23456789123'  
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it 'Input no campo ‘agência’ com mais de 10 casas decimais' do
      expect(@payment_transfer.response.code).to eql '400'
      expect((@payment_transfer.parsed_response)['obj.transfAgencia'][0]).to eql "The field transfAgencia must be a string or array type with a maximum length of '10'."
    end
  end

  context '[Bradesco] Input no campo ‘agência’ com dados vazio' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_bradesco).to_hash      
      transfer[:transfAgencia] = ''
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it { expect((@payment_transfer.parsed_response)['erros'][0]['mensagem']).to eql 'Bradesco: Agencia e Nome do Titular são obrigatórios' }
  end

  # ----------------------Conta Corrente------------------------------
  context '[Bradesco] Input no campo ‘conta corrente’ com mais de 10 casas decimais' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_bradesco).to_hash
      transfer[:transfConta] = '123456789123'
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it 'Input no campo ‘conta corrente’ com mais de 10 casas decimais' do
      expect(@payment_transfer.response.code).to eql '400'
      expect((@payment_transfer.parsed_response)['obj.transfConta'][0]).to eql "The field transfConta must be a string or array type with a maximum length of '10'."
    end
  end

  context '[Bradesco] Input no campo ‘conta corrente’ com menos de 4 casas decimais' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_bradesco).to_hash
      transfer[:transfConta] = '12'
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it { expect((@payment_transfer.parsed_response)['sucesso']).to be true }
  end

  context '[Bradesco] Input no campo ‘conta corrente’ com dados vazio  ' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_bradesco).to_hash
      transfer[:transfConta] = ''
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it { expect((@payment_transfer.parsed_response)['sucesso']).to be true }
  end

  context '[Itau] Realizar transferência com banco Itau' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_itau).to_hash      
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it 'Realizar transferência com banco Itau' do
      expect((@payment_transfer.parsed_response)['sucesso']).to be true
      expect((@payment_transfer.parsed_response)['obj'][0]['nomeBanco']).to eql 'Itaú'
      expect((@payment_transfer.parsed_response)['obj'][0]['idTipoFormaPagamentoFeito']).to be 7
    end
  end

  context '[Itaú] Realizar transferência com uma conta já salva' do
    before do
      TransferDB.new.delete_account(@idUsuario)
      TransferDB.new.insert_account(@idUsuario)

      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_itau).to_hash
      transfer[:transfAgencia] = '4242'
      transfer[:transfAgenciaDigito] = '4'
      transfer[:transfConta] = '1120'
      transfer[:transfContaDigito] = '7'
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end
    it { expect((@payment_transfer.parsed_response)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }
  end

  context '[Santander] Realizar transferência com banco Santander' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_santander).to_hash
      transfer[:cpf] = Faker::CPF.numeric
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it 'Realizar transferência com banco Santander' do
      expect((@payment_transfer.parsed_response)['sucesso']).to be true
      expect((@payment_transfer.parsed_response)['obj'][0]['nomeBanco']).to eql 'Banco Santander'
      expect((@payment_transfer.parsed_response)['obj'][0]['idTipoFormaPagamentoFeito']).to be 8
    end
  end

  context '[Santander] Realizar transferência com uma conta já salva' do
    before do
      TransferDB.new.delete_account(@idUsuario)
      TransferDB.new.insert_account(@idUsuario)

      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_santander).to_hash
      transfer[:cpf] = '66530420061'
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it { expect((@payment_transfer.parsed_response)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }
  end

  context '[Santander] Input no campo ‘cpf’ com dados numéricos aleatórios' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_santander).to_hash
      transfer[:cpf] = Faker::Bank.account_number(digits: 11)
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it { expect((@payment_transfer.parsed_response)['sucesso']).to be true }
  end

  context '[BBrasil] Realizar transferência com Banco do Brasil' do
    before do
      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_bbrasil).to_hash
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it '[BBrasil] Realizar transferência com banco Brasil' do
      expect((@payment_transfer.parsed_response)['sucesso']).to be true
      expect((@payment_transfer.parsed_response)['obj'][0]['nomeBanco']).to eql 'Banco do Brasil'
      expect((@payment_transfer.parsed_response)['obj'][0]['idTipoFormaPagamentoFeito']).to be 9
    end
  end

  context '[BBrasil] Realizar transferência com uma conta já salva do Brasil' do
    before do
      TransferDB.new.delete_account(@idUsuario)
      TransferDB.new.insert_account(@idUsuario)

      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      transfer = build(:transfer_bbrasil).to_hash
      transfer[:transfAgencia] = '8080'
      transfer[:transfAgenciaDigito] = '7'
      transfer[:transfConta] = '5966'
      transfer[:transfContaDigito] = '8'
      @payment_transfer = ApiTransfer.post_transfer(@token, idCarrinho, transfer)
    end

    it { expect((@payment_transfer.parsed_response)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }
  end
end
