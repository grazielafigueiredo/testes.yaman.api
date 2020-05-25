# frozen_string_literal: true

describe 'Resgate' do

  context 'Regatar valor pelo banco Bradesco e validar saldo restante   ' do
    valor = 10.000
    idBanco = 1
    agenciaNumero = Faker::Bank.account_number(digits: 4)
    agenciaDigito = Faker::Bank.account_number(digits: 1)
    contaNumero = Faker::Bank.account_number(digits: 10)
    contaDigito = Faker::Bank.account_number(digits: 1)

      before do
        @token = ApiUser.GetToken
        ApiUser.Login(@token, Constant::User1)
        
        Database.new.update_PremioResgate(50)

        @pedidoResgate = ApiResgate.post_setResgate(
          valor,
          @token,
          idBanco,
          agenciaNumero,
          agenciaDigito,
          contaNumero,
          contaDigito
        )
        puts @pedidoResgate
        @statusResgate = ApiResgate.get_statusResgate(@token)
        puts @statusResgate
      end
    # end 
      
      
      it 'Sucesso com verificação de valor sacado -  Bradesco' do 
        expect(JSON.parse(@statusResgate.response.body)['obj'][0]['saldoPremio']).to be 40.0 
        expect(JSON.parse(@statusResgate.response.body)['sucesso']).to be true
        expect(JSON.parse(@pedidoResgate.response.body)['obj'][0]['valor']).to be 5.25 #valor irá alterar conforme taxa de resgate
        expect(JSON.parse(@pedidoResgate.response.body)['sucesso']).to be true
      end
      
      after do
        Database.new.update_PremioResgate(0)
        ApiUser.get_deslogar(@token)
      end
  end

  context 'Sucesso com verificação de valor sacado' do
    valor = 10.000
    idBanco = 3
    agenciaNumero = Faker::Bank.account_number(digits: 4)
    agenciaDigito = Faker::Bank.account_number(digits: 1)
    contaNumero = Faker::Bank.account_number(digits: 10)
    contaDigito = Faker::Bank.account_number(digits: 1)


    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_PremioResgate(50)
      @pedidoResgate = ApiResgate.post_setResgate(
          valor,
          @token,
          idBanco,
          agenciaNumero,
          agenciaDigito,
          contaNumero,
          contaDigito
      )
      puts @pedidoResgate
      @statusResgate = ApiResgate.get_statusResgate(@token)
      puts @statusResgate
    end

    it 'Sucesso com verificação de valor sacado -  Santander' do 
      expect(JSON.parse(@statusResgate.response.body)['obj'][0]['saldoPremio']).to be 40.0 
      expect(JSON.parse(@statusResgate.response.body)['sucesso']).to be true
      expect(JSON.parse(@pedidoResgate.response.body)['obj'][0]['valor']).to be 5.25 #valor irá alterar conforme taxa de resgate
      expect(JSON.parse(@pedidoResgate.response.body)['sucesso']).to be true
    end

    after do
      Database.new.update_PremioResgate(0)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Resgatar valor acima do valor disponível' do
    valor = 100.000
    idBanco = 1
    agenciaNumero = Faker::Bank.account_number(digits: 4)
    agenciaDigito = Faker::Bank.account_number(digits: 1)
    contaNumero = Faker::Bank.account_number(digits: 10)
    contaDigito = Faker::Bank.account_number(digits: 1)

    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_PremioResgate(50)
      @pedidoResgate = ApiResgate.post_setResgate(
        valor,
        @token,
        idBanco,
        agenciaNumero,
        agenciaDigito,
        contaNumero,
        contaDigito
      )
      puts @pedidoResgate
    end

    it 'Sacar saldo insuficiente' do 
      expect(JSON.parse(@pedidoResgate.response.body)['erros'][0]['mensagem']).to eql "Não é possível resgatar o valor solicitado (saldo insuficiente)"
    end

    after do
      Database.new.update_PremioResgate(0)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Resgatar valor inserindo outros dados bancários  ' do
    valor = 10.000
    idBanco = 1
    agenciaNumero = 123
    agenciaDigito = 1
    contaNumero = 1234567890
    contaDigito = 1

    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_PremioResgate(50.000)
      @res = ApiResgate.post_setResgate(
        valor,
        @token,
        idBanco,
        agenciaNumero,
        agenciaDigito,
        contaNumero,
        contaDigito
      )
      puts @res
    end

    it { expect(JSON.parse(@res.response.body)['sucesso']).to be true}

    after do
      Database.new.update_PremioResgate(0.000)
      ApiUser.get_deslogar(@token)
    end
  end
end
