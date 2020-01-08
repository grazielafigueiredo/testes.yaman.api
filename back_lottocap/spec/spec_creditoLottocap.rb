# criar teste para sacar valor além do saldo
context 'Comprar créditos Lottocap' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

    @result = ApiCreditoLottocap.post_comprarCreditoLottocap(@token, @idCarrinho)
    puts @result
  end
  it { expect(JSON.parse(@result.response.body)['sucesso']).to be true}
 
  after do
    Database.new.update_CreditoLottocap(0.000)
    ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
    ApiUser.get_deslogar(@token)
  end
end

context 'Pagar - Sucesso com Crédito Lottocap' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    Database.new.update_CreditoLottocap(100)

    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(3, Constant::IdProduto, Constant::IdSerie, @token)
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

    @result = ApiCreditoLottocap.post_CreditoLottocap(@token, @idCarrinho)
    puts @result
  end

  it 'Pagar - Sucesso com Crédito Lottocap' do
     expect(JSON.parse(@result.response.body)['sucesso']).to be true
     expect(JSON.parse(@result.response.body)['dadosUsuario']['creditosDisponiveis']).to eql 70.000
  end
  
  after do
    Database.new.update_CreditoLottocap(0)
    ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
    ApiUser.get_deslogar(@token)
  end
end 

context 'Pagar - Teste de compra com JÁ18' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    Database.new.update_CreditoLottocap(100.000)

    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(3, Constant::IdProdutoJa18, Constant::IdSerieJa18, @token)
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
    puts @carrinho
    @result = ApiCreditoLottocap.post_CreditoLottocap(@token, @idCarrinho)
    puts @result
  end
  
  it 'Pagar - Teste de compra com JÁ18' do
   expect(JSON.parse(@result.response.body)['sucesso']).to be true
   expect(JSON.parse(@result.response.body)['dadosUsuario']['creditosDisponiveis']).to eql 25.000
  end
  
  after do
    Database.new.update_CreditoLottocap(0.000)
    ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
    ApiUser.get_deslogar(@token)
  end
end

