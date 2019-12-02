# frozen_string_literal: true


describe 'Bradesco' do
  context 'Transferência Bancária Sucesso (Bradesco)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), Constant::NomeCompletoTitular)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Bradesco' }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 6 }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Reservar série 86' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_reservarSerie(1)
      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), Constant::NomeCompletoTitular)
      sleep(5)
      
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Não foi possível Reservar os Titulos Solicitados!' }

    it { puts @result.response.body}
    
    after do
      Database.new.update_reservarSerie(0)
      sleep(5)
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  #  # ----------------------Digito------------------------------

  context 'Transferência Bancária Dígito Null' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 4), '', Constant::NomeCompletoTitular)
    end
    it { expect(@result.response.code).to eql '200' }
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

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 3), Constant::NomeCompletoTitular)
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

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), "")
    end
    it { expect(@result.response.code).to eql '200' }
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

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 1), Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), Constant::NomeCompletoTitular)
    end
    it { expect(@result.response.code).to eql '200' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Transferência Bancária Agencia > que 4 dígitos' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 11), Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), Constant::NomeCompletoTitular)
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)['obj.transfAgencia'][0]).to eql "The field transfAgencia must be a string or array type with a maximum length of '10'." }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Transferência Bancária Agência Null' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, '', Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), Constant::NomeCompletoTitular)
    end
    it { expect(@result.response.code).to eql '200' }
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

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 20), Faker::Bank.account_number(digits: 1), Constant::NomeCompletoTitular)
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

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 2), Faker::Bank.account_number(digits: 1), Constant::NomeCompletoTitular)
    end
    it { expect(@result.response.code).to eql '200' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Transferência Bancária Conta Corrente Null' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), '', Faker::Bank.account_number(digits: 1), Constant::NomeCompletoTitular)
    end
    it { expect(@result.response.code).to eql '200' }

    # it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Object reference not set to an instance of an object.' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'Itau' do
  context 'Transferência Bancária Sucesso (Itau)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSucessoItau(@token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Itaú' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'Santander' do
  context 'Transferência Bancária Sucesso (Santander)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSantander(@token, @idCarrinho, Faker::CPF.numeric)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Banco Santander' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'CPF inválido' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSantander(@token, @idCarrinho, Faker::Bank.account_number(digits: 11))
    end
    it { expect(@result.response.code).to eql '200' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'Brasil' do
  context 'Transferência Bancária Sucesso (Brasil)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSucessoBrasil(@token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Banco do Brasil' }

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end
