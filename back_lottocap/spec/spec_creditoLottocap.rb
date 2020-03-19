# criar teste para sacar valor além do saldo
context 'Comprar créditos Lottocap' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
      1,
      Constant::IdProduto,
      Constant::IdSerie,
      @token
    )
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

    @responseCarrinho = ApiCreditoLottocap.post_comprarCreditoLottocap(@token, @idCarrinho)
    puts @responseCarrinho
  end
  it { expect(JSON.parse(@responseCarrinho.response.body)['sucesso']).to be true}
 
  after do
    CreditoLotto.new.update_creditoLottocap(0.000)
    ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
    ApiUser.get_deslogar(@token)
  end
end

context 'Pagar - Sucesso com Crédito Lottocap' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    CreditoLotto.new.update_creditoLottocap(100)

    @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
      1,
      Constant::IdProduto,
      Constant::IdSerie,
      @token
    )
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
  
    @responseCarrinho = ApiCreditoLottocap.post_pagarCarrinhoComCreditoLottocap(@token, @idCarrinho)

    @responseDadosUsuario = ApiCreateUser.get_buscarDadosUsuario(@token)
    puts @responseDadosUsuario
  end

  it 'Pagar - Sucesso com Crédito Lottocap' do
     expect(JSON.parse(@responseCarrinho.response.body)['sucesso']).to be true
     expect(JSON.parse(@responseDadosUsuario.response.body)['obj'][0]['dadosUsuario']['creditosDisponiveis']).to eql 50.000
    end
  
  after do
    CreditoLotto.new.update_creditoLottocap(0)
    ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
    ApiUser.get_deslogar(@token)
  end
end 

context 'Pagar - Teste de compra com JÁ18' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    CreditoLotto.new.update_creditoLottocap(100.000)

    @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
      1,
      Constant::IdProdutoJa18,
      Constant::IdSerieJa18,
      @token
    )
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

    @responseCarrinho = ApiCreditoLottocap.post_pagarCarrinhoComCreditoLottocap(@token, @idCarrinho)

    @responseDadosUsuario = ApiCreateUser.get_buscarDadosUsuario(@token)
    puts @responseDadosUsuario
  end
  
  it 'Pagar - Teste de compra com JÁ18' do
   expect(JSON.parse(@responseCarrinho.response.body)['sucesso']).to be true
   expect(JSON.parse(@responseDadosUsuario.response.body)['obj'][0]['dadosUsuario']['creditosDisponiveis']).to eql 99.000
  end
  
  after do
    CreditoLotto.new.update_creditoLottocap(0.000)
    ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
    ApiUser.get_deslogar(@token)
  end
end

