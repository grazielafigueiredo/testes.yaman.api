describe 'Resgate' do

    context 'Sucesso com verificação de valor sacado' do
      before do
        @token = ApiUser.GetToken
        ApiUser.Login(@token, Constant::User1)
  
        Database.new.update_PremioResgate(50.000)
        @res = ApiResgate.post_ResgateSucesso(10.000, @token)
        puts @res
        @resgate = ApiResgate.get_StatusResgate
        puts @resgate
      end

      # it { expect(JSON.parse(@resgate.response.body)['dadosUsuario']['premiosGanhos']).to be == 40.000}
      it { expect(JSON.parse(@resgate.response.body)['obj']['saldoResgatavel']).to be 50.0}

      after do
        # Database.new.update_PremioResgate(0.000)
        ApiUser.get_deslogar(@token)
      end

    end
end