
  context 'Sucesso com Crédito Lottocap' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_insertCreditoLottocap

      @result = ApiCarrinho.post_AdicionarItemCarrinho(1, @token)
      @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']

      @carrinho = ApiCreditoLottocap.post_SucessoCreditoLottocap(@token, @idCarrinho)
    end

    it { expect(JSON.parse(@carrinho.response.body)['sucesso'][0]).to be true}
    it { puts @carrinho.response.body}
    
    after do
      Database.new.update_deleteCreditoLottocap
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end