# frozen_string_literal: true

describe 'Resgate' do
  context 'Sucesso com verificação de valor sacado' do
    # while bancos <= 0
    #   bancos = 0
    #   bancos += 1
      before do
        @token = ApiUser.GetToken
        ApiUser.Login(@token, Constant::User1)
        
        Database.new.update_PremioResgate(5000)
        puts bancos
        @pedidoResgate = ApiResgate.post_SetResgate(10.000, @token, bancos.to_s, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), Faker::Bank.account_number(digits: 10), Faker::Bank.account_number(digits: 1))
        puts @pedidoResgate
        @statusResgate = ApiResgate.get_StatusResgate(@token)
        # puts @statusResgate
      end
    # end 
      
      
      it 'Sucesso com verificação de valor sacado -  Bradesco' do 
        # expect(JSON.parse(@statusResgate.response.body)['dadosUsuario']['premiosGanhos']).to be 40.0 
        expect(JSON.parse(@statusResgate.response.body)['sucesso']).to be true
        # expect(JSON.parse(@pedidoResgate.response.body)['obj'][0]['valor']).to be 5.25 #valor irá alterar conforme taxa de resgate
        expect(JSON.parse(@pedidoResgate.response.body)['sucesso']).to be true
      end
      
      after do
        Database.new.update_PremioResgate(0)
        ApiUser.get_deslogar(@token)
      end
  end

  context 'Sucesso com verificação de valor sacado' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_PremioResgate(50)
      @pedidoResgate = ApiResgate.post_SetResgate(10.000, @token, 3, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), Faker::Bank.account_number(digits: 10), Faker::Bank.account_number(digits: 1))
      puts @pedidoResgate
      @statusResgate = ApiResgate.get_StatusResgate(@token)
      # puts @statusResgate
    end

    it 'Sucesso com verificação de valor sacado -  Santander' do 
      expect(JSON.parse(@statusResgate.response.body)['dadosUsuario']['premiosGanhos']).to be 40.0 
      expect(JSON.parse(@statusResgate.response.body)['sucesso']).to be true
      expect(JSON.parse(@pedidoResgate.response.body)['obj'][0]['valor']).to be 5.25 #valor irá alterar conforme taxa de resgate
      expect(JSON.parse(@pedidoResgate.response.body)['sucesso']).to be true
    end

    after do
      Database.new.update_PremioResgate(0)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Sacar saldo insuficiente' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_PremioResgate(50)
      @pedidoResgate = ApiResgate.post_SetResgate(100.000, @token, 1, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), Faker::Bank.account_number(digits: 10), Faker::Bank.account_number(digits: 1))
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

  context 'Conta existente para saca' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_PremioResgate(50.000)
      @res = ApiResgate.post_SetResgate(10.000, @token, 1, 1234, 1, 1234567890, 1)
      puts @res
    end

    it { expect(JSON.parse(@res.response.body)['sucesso']).to be true}

    after do
      Database.new.update_PremioResgate(0.000)
      ApiUser.get_deslogar(@token)
    end
  end
end
