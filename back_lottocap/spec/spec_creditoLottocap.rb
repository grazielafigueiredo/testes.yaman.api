
context 'Pagar - Sucesso com Crédito Lottocap' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    Database.new.update_CreditoLottocap(100.000)

    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(3, Constant::IdProduto, Constant::IdSerie, @token)
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

    @result = ApiCreditoLottocap.post_CreditoLottocap(@token, @idCarrinho)
  end

  it { expect(JSON.parse(@result.response.body)['sucesso']).to be true}
  it { expect(JSON.parse(@result.response.body)['dadosUsuario']['creditosDisponiveis']).to eql 70.000}
  it { puts @result.response.body}
  
  after do
    Database.new.update_CreditoLottocap(0.000)
    ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
    ApiUser.get_deslogar(@token)
  end
end

context 'Comprar créditos Lottocap' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

    @result = ApiCreditoLottocap.post_comprarCreditoLottocap(@token, @idCarrinho)
  end
  it { expect(JSON.parse(@result.response.body)['sucesso']).to be true}
  it { puts @result.response.body}
 
  after do
    Database.new.update_CreditoLottocap(0.000)
    ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
    ApiUser.get_deslogar(@token)
  end
end