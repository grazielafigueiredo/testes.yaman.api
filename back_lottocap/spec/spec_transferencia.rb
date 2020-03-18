# frozen_string_literal: true


describe 'Bradesco' do

  dataVincenda = '2020-12-25'

  context 'Transferência Bancária Sucesso (Bradesco)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerie,
        @token
      )
      puts @carrinho
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), Constant::NomeCompletoTitular)
      puts @result
    end

    it 'validaçåo tipo de transf. Bradesco' do 
      expect(JSON.parse(@result.response.body)['sucesso']).to be true 
      expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Bradesco' 
      expect(JSON.parse(@result.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 6 
    end 

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Conta já cadastrada anteriormente (Bradesco)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerie,
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        '1234', 
        '5678', 
        '9', 
        Constant::NomeCompletoTitular
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Reservar série 86' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerie,
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_reservarSerie(1)
      # sleep 10
      @result = ApiTransferencia.post_TransfBradesco(
        @token,
        @idCarrinho,
        Faker::Bank.account_number(digits: 4),
        Faker::Bank.account_number(digits: 4),
        Faker::Bank.account_number(digits: 1),
        Constant::NomeCompletoTitular
      )
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

  context 'Transferência Bancária Dígito Null' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerie,
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token,
        @idCarrinho,
        Faker::Bank.account_number(digits: 4),
        Faker::Bank.account_number(digits: 4),
        '',
        Constant::NomeCompletoTitular
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['obj'][0]['digitoAgencia']).to eql '' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Transferência Bancária Dígito > que 1 dígito' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerie,
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token,
        @idCarrinho,
        Faker::Bank.account_number(digits: 4),
        Faker::Bank.account_number(digits: 4),
        Faker::Bank.account_number(digits: 3),
        Constant::NomeCompletoTitular
      )
      puts @result
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)['obj.transfContaDigito'][0]).to eql "The field transfContaDigito must be a string or array type with a maximum length of '1'." }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  # ----------------------Nome Transferencia------------------------------

  context 'Transferência Bancária Nome Null' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1), 
        ""
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Bradesco: Agencia e Nome do Titular são obrigatórios' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  # ----------------------Agencia Bancaria------------------------------

  context 'Transferência Bancária Agência < que 4 dígitos' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 1), 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1), 
        Constant::NomeCompletoTitular
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Transferência Bancária Agencia > que 4 dígitos' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 11), 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1), 
        Constant::NomeCompletoTitular
      )
      puts @result
    end
    it 'Transferência Bancária Agencia > que 4 dígitos' do
      expect(@result.response.code).to eql '400' 
      expect(JSON.parse(@result.response.body)['obj.transfAgencia'][0]).to eql "The field transfAgencia must be a string or array type with a maximum length of '10'." 
    end
    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Transferência Bancária Agência Null' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        '', 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1), 
        Constant::NomeCompletoTitular
      )

      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Bradesco: Agencia e Nome do Titular são obrigatórios' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  # ----------------------Conta Corrente------------------------------
  context 'Transferência Bancária Conta Corrente > que 10 dígitos' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 20), 
        Faker::Bank.account_number(digits: 1), 
        Constant::NomeCompletoTitular
      )
      puts @result
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)['obj.transfConta'][0]).to eql "The field transfConta must be a string or array type with a maximum length of '10'." }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Transferência Bancária Conta Corrente < que 4 dígitos' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 2), 
        Faker::Bank.account_number(digits: 1), 
        Constant::NomeCompletoTitular
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Transferência Bancária Conta Corrente Null' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), '', Faker::Bank.account_number(digits: 1), Constant::NomeCompletoTitular)
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

  context 'Transferência Bancária Sucesso (Itau)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfItau(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1)
      )
      puts @result
    end

    it 'validaçåo tipo de transf. Banco Itaú' do 
      expect(JSON.parse(@result.response.body)['sucesso']).to be true 
      expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Itaú'
      expect(JSON.parse(@result.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 7
    end

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Conta já cadastrada anteriormente (Itau)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfItau(
        @token, 
        @idCarrinho, 
        '1111', 
        '1234', 
        '1'
      )
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

  context 'Transferência Bancária Sucesso (Santander)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSantander(
        @token, 
        @idCarrinho, 
        Faker::CPF.numeric
      )
      puts @result
    end

    it 'validaçåo tipo de transf. Banco Santander' do 
      expect(JSON.parse(@result.response.body)['sucesso']).to be true 
      expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Banco Santander'
      expect(JSON.parse(@result.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 8
    end

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Conta já cadastrada anteriormente (Santander)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSantander(
        @token, 
        @idCarrinho, 
        '00000009652'
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'CPF inválido' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSantander(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 11)
      )
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

  context 'Transferência Bancária Sucesso (Brasil)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSucessoBrasil(
        @token, 
        @idCarrinho, 
        Faker::Bank.account_number(digits: 4), 
        Faker::Bank.account_number(digits: 1), 
        Faker::Bank.account_number(digits: 10), 
        Faker::Bank.account_number(digits: 1) 
      )
      puts @result
    end
    it 'validaçåo tipo de transf. Banco do Brasil' do 
      expect(JSON.parse(@result.response.body)['sucesso']).to be true 
      expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Banco do Brasil'
      expect(JSON.parse(@result.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 9 
    end

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Conta já cadastrada anteriormente (Brasil)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerie, 
        @token
      )
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSucessoBrasil(
        @token, 
        @idCarrinho, 
        '1069', 
        '3', 
        '20262', 
        '2'
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Essa conta bancária já foi adicionada anteriormente.' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end
