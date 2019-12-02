describe 'Resgate' do

    context 'Sucesso com verificação de valor sacado' do
      before do
        @token = ApiUser.GetToken
        ApiUser.Login(@token, Constant::User1)
  
        Database.new.update_PremioResgate(50)
        ApiResgate.post_ResgateSucesso(10.000, @token)
        @resgate = ApiResgate.get_StatusResgate
      end

      it { expect(JSON.parse(@resgate.response.body)['dadosUsuario']['premiosGanhos']).to matcher = 40.000}
      it { puts @resgate.response.body}

      after do
        Database.new.update_PremioResgate(0)
        ApiUser.get_deslogar(@token)
      end

    end
end