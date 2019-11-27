# # frozen_string_literal: true

describe 'Bradesco' do

  context 'Transferência Bancária Sucesso (Bradesco)' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiTransferencia.post_TransfSucessoBradesco(@token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql "Bradesco" }
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
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
    
      Database.new.update_reservarSerie86
      @result = ApiTransferencia.post_TransfSucessoBradesco(@token, @idCarrinho)
      sleep(5)
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Não foi possível Reservar os Titulos Solicitados!"}

    after do
      Database.new.update_disponibilizarSerie86 
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
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiTransferencia.post_TransfDigitoInvalido("", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    # it { expect(JSON.parse(@result.response.body)['obj'][0]['idTipoFormaPagamentoFeito']).to be 6 }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['digitoAgencia']).to eql "" }
    
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end

  context 'Transferência Bancária Dígito > que 1 dígito' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiTransferencia.post_TransfDigitoInvalido(Faker::Bank.account_number(digits: 3), @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)["obj.transfContaDigito"][0]).to eql "The field transfContaDigito must be a string or array type with a maximum length of '1'."}
    
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
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiTransferencia.post_TransfNomeInvalido("", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Bradesco: Agencia e Nome do Titular são obrigatórios"}

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
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiTransferencia.post_TransfAgenciaInvalida(Faker::Bank.account_number(digits: 1), @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    # it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Object reference not set to an instance of an object.' }
  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end

  context 'Transferência Bancária Agencia > que 4 dígitos' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiTransferencia.post_TransfAgenciaInvalida(Faker::Bank.account_number(digits: 12), @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)['obj.transfAgencia'][0]).to eql "The field transfAgencia must be a string or array type with a maximum length of '10'."}
    
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end

  context 'Transferência Bancária Agência Null' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiTransferencia.post_TransfAgenciaInvalida("", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Bradesco: Agencia e Nome do Titular são obrigatórios"}

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
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiTransferencia.post_TransfContaInvalida(Faker::Bank.account_number(digits: 11), @token, @idCarrinho)
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
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfContaInvalida(Faker::Bank.account_number(digits: 2), @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    # it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Object reference not set to an instance of an object." }
  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end

  context 'Transferência Bancária Conta Corrente Null' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfContaInvalida("", @token, @idCarrinho)
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
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
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
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSucessoSantander(@token, @idCarrinho)
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
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiTransferencia.post_TransfSantanderInvalido(Faker::Bank.account_number(digits: 11), @token, @idCarrinho)
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
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
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
