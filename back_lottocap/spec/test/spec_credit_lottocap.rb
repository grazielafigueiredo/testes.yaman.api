# frozen_string_literal: true

# criar teste para pagar com valor além do produto
context 'Comprar créditos com valor mínimo de R$20,00' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, build(:login).to_hash)

    @credit = build(:buy_credit).to_hash
    @buy_credit = ApiCreditoLottocap.post_buy_credit(@token, @credit)
  end

  it { expect((@buy_credit.parsed_response)['sucesso']).to be true }

  after do
    ApiUser.get_logout(@token)
  end
end

context 'Pagar com créditos produto MAX' do
  before do
    @token = ApiUser.GetToken
    @login = ApiUser.Login(@token, build(:login).to_hash)
    @idUsuario = @login.parsed_response['obj'][0]['idUsuario']
    CreditoLotto.new.update_creditoLottocap(100, @idUsuario)

    @cart = build(:cart).to_hash
    @carrinho = ApiCart.post_add_item_cart(@token, @cart)
    @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

    @credit = build(:payment_credit).to_hash
    @payment_credit = ApiCreditoLottocap.post_payment_credit_lottocap(@token, @idCarrinho, @credit)

    @responseDadosUsuario = ApiCreateUser.get_buscarDadosUsuario(@token)
  end

  it 'Pagar com créditos produto MAX' do
    expect((@payment_credit.parsed_response)['sucesso']).to be true
    expect((@responseDadosUsuario.parsed_response)['obj'][0]['dadosUsuario']['creditosDisponiveis']).to eql 50.000
  end

  after do
    ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
    ApiUser.get_logout(@token)
  end
end

context 'Pagar com créditos produto Já 18' do
  before do
    @token = ApiUser.GetToken
    @login = ApiUser.Login(@token, build(:login).to_hash)
    @idUsuario = @login.parsed_response['obj'][0]['idUsuario']
    CreditoLotto.new.update_creditoLottocap(100, @idUsuario)

    @cart = build(:cart).to_hash
    @cart[:idProduto] = Constant::IdProdutoJa18
    @cart[:idSerie] = Constant::IdSerieJa18
    @carrinho = ApiCart.post_add_item_cart(@token, @cart)
    @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

    @credit = build(:payment_credit).to_hash
    @payment_credit = ApiCreditoLottocap.post_payment_credit_lottocap(@token, @idCarrinho, @credit)

    @responseDadosUsuario = ApiCreateUser.get_buscarDadosUsuario(@token)
  end

  it 'Pagar com créditos produto Já 18' do
    expect((@payment_credit.parsed_response)['sucesso']).to be true
    expect((@responseDadosUsuario.parsed_response)['obj'][0]['dadosUsuario']['creditosDisponiveis']).to eql 99.000
  end

  after do
    ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
    ApiUser.get_logout(@token)
  end
end
