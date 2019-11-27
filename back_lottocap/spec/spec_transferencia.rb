# # frozen_string_literal: true

describe 'Bradesco' do

  context 'Transferência Bancária Sucesso (Bradesco)' do
    before do
      @result = ApiTransferencia.post_TransfSucessoBradesco
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Bradesco' }
  end


 # ----------------------Digito------------------------------ 

  context 'Transferência Bancária Dígito Null' do
    before do
      @result = ApiTransferencia.post_TransfDigitoInvalido("")
    end
    it { expect(@result.response.code).to eql '200' }
  end

  context 'Transferência Bancária Dígito > que 1 dígitos' do
    before do
      @result = ApiTransferencia.post_TransfDigitoInvalido("3")
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Object reference not set to an instance of an object.' }
  end  


# ----------------------Agencia Bancaria------------------------------ 
 
  context 'Transferência Bancária Nome Null' do
    before do
      @result = ApiTransferencia.post_TransfNomeNull
    end
    it { expect(@result.response.code).to eql '500' }
  end



 # ----------------------Agencia Bancaria------------------------------ 

  context 'Transferência Bancária Agência < que 4 dígitos' do
    before do
      @result = ApiTransferencia.post_TransfAgenciaInvalida("1")
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Object reference not set to an instance of an object.' }
  end

  context 'Transferência Bancária Agencia > que 4 dígitos' do
    before do
      @result = ApiTransferencia.post_TransfAgenciaInvalida("123456")
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Object reference not set to an instance of an object." }
  end

  context 'Transferência Bancária Agência Null' do
    before do
      @result = ApiTransferencia.post_TransfAgenciaInvalida("")
    end
    it { expect(@result.response.code).to eql '500' }
  end



 # ----------------------Conta Corrente------------------------------ 
  context 'Transferência Bancária Conta Corrente > que 10 dígitos' do
    before do
      @result = ApiTransferencia.post_TransfContaInvalida("1123456aa1234567894567")
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)['obj.transfConta'][0]).to eql "The field transfConta must be a string or array type with a maximum length of '10'." }
  end

  context 'Transferência Bancária Conta Corrente < que 4 dígitos' do
    before do
      @result = ApiTransferencia.post_TransfContaInvalida("112")
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Object reference not set to an instance of an object." }
  end

  context 'Transferência Bancária Conta Corrente Null' do
    before do
      @result = ApiTransferencia.post_TransfContaInvalida("")
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(@result.response.code).to eql 'Object reference not set to an instance of an object.' }
  end

end

describe 'Itau' do
  context 'Transferência Bancária Sucesso (Itau)' do
    before do
      @result = ApiTransferencia.post_TransfSucessoItau
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Itaú' }

  end
end

describe 'Santander' do
  context 'Transferência Bancária Sucesso (Santander)' do
    before do
      @result = ApiTransferencia.post_TransfSucessoSantander
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Santander' }
  end

  context 'CPF inválido' do
    before do
      @result = ApiTransferencia.post_TransfSantanderInvalido("00000000011")
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['nomeBanco']).to eql 'Santander' }
  end
end

describe 'Brasil' do

end
