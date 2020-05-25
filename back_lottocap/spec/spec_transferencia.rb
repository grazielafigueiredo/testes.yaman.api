# frozen_string_literal: true


describe 'Bradesco' do

  dataVincenda = '2020-12-25'

  context 'Realizar transferência com banco Bradesco' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), 'CARLOS')
      puts @carrinho
      puts @idCarrinho
      puts @result
    end

    it 'Realizar transferência com banco Bradesco' do 
      expect(JSON.parse(@result.response.body)['sucesso']).to be true 
      expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Bradesco' 
      expect(JSON.parse(@result.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 6 
    end 

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Realizar transferência com uma conta já salva do Bradesco' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        '1234', 
        '5678', 
        '9', 
        'CARLOS'
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Tentar pagar com transferencia bancária um produto que esgotou as vendas, produto já reservado' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_reservarSerie(1)
      # sleep 10
      @result = ApiTransferencia.post_TransfBradesco(
        @token,
        @idCarrinho,
        Faker::Bank.account_number(digits: 4),
        Faker::Bank.account_number(digits: 4),
        Faker::Bank.account_number(digits: 1),
        'CARLOS'
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Não foi possível Reservar os Titulos Solicitados!' }

    
    after do
      Database.new.update_reservarSerie(0)
      # sleep 10
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  #  # ----------------------Digito------------------------------

  context 'Input no campo ‘digito da conta’ com dados vazio' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token,
        @idCarrinho,
        Faker::Bank.account_number(digits: 4),
        Faker::Bank.account_number(digits: 4),
        '',
        'CARLOS'
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['obj'][0]['digitoAgencia']).to eql '' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Input no campo ‘digito da conta’ acima de 1 casa decimal' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token,
        @idCarrinho,
        Faker::Bank.account_number(digits: 4),
        Faker::Bank.account_number(digits: 4),
        Faker::Bank.account_number(digits: 3),
        'CARLOS'
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it "Input no campo ‘digito da conta’ acima de 1 casa decimal" do 
      expect(@result.response.code).to eql '400' 
      expect(JSON.parse(@result.response.body)['obj.transfContaDigito'][0]).to eql "The field transfContaDigito must be a string or array type with a maximum length of '1'."
    end

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  # ----------------------Nome Transferencia------------------------------

  context 'Input no campo ‘digito da conta’ com dados vazio' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1), 
        ""
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Bradesco: Agencia e Nome do Titular são obrigatórios' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  # ----------------------Agencia Bancaria------------------------------

  context 'Input no campo ‘agência’ com menos de 4 casa decimal' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 1), 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1), 
        'CARLOS'
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Input no campo ‘agência’ com mais de 4 casa decimal' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 11), 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1), 
        'CARLOS'
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it 'Input no campo ‘agência’ com menos de 4 casa decimal' do
      expect(@result.response.code).to eql '400' 
      expect(JSON.parse(@result.response.body)['obj.transfAgencia'][0]).to eql "The field transfAgencia must be a string or array type with a maximum length of '10'." 
    end
    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Input no campo ‘agência’ com dados vazio' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        '', 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1), 
        'CARLOS'
      )

      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Bradesco: Agencia e Nome do Titular são obrigatórios' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  # ----------------------Conta Corrente------------------------------
  context 'Input no campo ‘conta corrente’ com mais de 10 casa decimal  ' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 20), 
        Faker::Bank.account_number(digits: 1), 
        'CARLOS'
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it 'Input no campo ‘conta corrente’ com mais de 10 casa decimal    ' do
      expect(@result.response.code).to eql '400'
      expect(JSON.parse(@result.response.body)['obj.transfConta'][0]).to eql "The field transfConta must be a string or array type with a maximum length of '10'."
    end

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Input no campo ‘conta corrente’ com menos de 4 casa decimal' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 2), 
        Faker::Bank.account_number(digits: 1), 
        'CARLOS'
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Input no campo ‘conta corrente’ com dados vazio  ' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), '', Faker::Bank.account_number(digits: 1), 'CARLOS')
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    # it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Object reference not set to an instance of an object.' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'Itau' do

  dataVincenda = '2020-12-25'

  context 'Realizar transferência com banco Itaú' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfItau(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1)
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end

    it 'Realizar transferência com banco Itaú' do 
      expect(JSON.parse(@result.response.body)['sucesso']).to be true 
      expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Itaú'
      expect(JSON.parse(@result.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 7
    end

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Realizar transferência com uma conta já salva do Itaú' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfItau(
        @token, 
        @idCarrinho, 
        '1111', 
        '1234', 
        '1'
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'Santander' do

  dataVincenda = '2020-12-25'

  context 'Realizar transferência com banco Santander' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSantander(
        @token, 
        @idCarrinho, 
        Faker::CPF.numeric
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end

    it 'Realizar transferência com banco Santander' do 
      expect(JSON.parse(@result.response.body)['sucesso']).to be true 
      expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Banco Santander'
      expect(JSON.parse(@result.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 8
    end

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Realizar transferência com uma conta já salva do Santander' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSantander(
        @token, 
        @idCarrinho, 
        '00000009652'
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Input no campo ‘cpf’ com dados numéricos aleatórios - Santander' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSantander(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 11)
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'Brasil' do

  dataVincenda = '2020-12-25'

  context 'Realizar transferência com banco Brasil' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSucessoBrasil(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1), 
        Faker::Bank.account_number(digits: 10), 
        Faker::Bank.account_number(digits: 1) 
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it 'Realizar transferência com banco Brasil' do 
      expect(JSON.parse(@result.response.body)['sucesso']).to be true 
      expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Banco do Brasil'
      expect(JSON.parse(@result.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 9 
    end

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Realizar transferência com uma conta já salva do Brasil' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSucessoBrasil(
        @token, 
        @idCarrinho, 
        '1069', 
        '3', 
        '20262', 
        '2'
      )
      puts @carrinho
      puts @idCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end
