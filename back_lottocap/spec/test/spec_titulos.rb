# frozen_string_literal: true

describe 'Títulos' do
  context 'Buscar por títulos agrupados por série' do
    let(:result) { ApiTitulos.post_group_titulos_serie(@token) }
    it { expect(result.parsed_response['sucesso']).to be true }
  end

  context 'Buscar por títulos novos' do
    let(:result) { ApiTitulos.post_get_new_titulo(@token) }
    it { expect(result.parsed_response['sucesso']).to be true }
  end
end

describe 'Verificar Premio Titulo' do
  context 'Verificar título premiado de outro usuário' do
    before do
      idTitulo = build(:titulo).to_hash
      idTitulo[:idTitulo] = 89
      @result = ApiTitulos.post_premium_titulo(@token, idTitulo)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Este título não pertence ao usuário!' }
  end

  context 'Passando id inexistente no Json' do
    before do
      idTitulo = build(:titulo).to_hash
      idTitulo[:idTitulo] = 12_345_678_901
      @result = ApiTitulos.post_premium_titulo(@token, idTitulo)
    end

    it { expect(@result.parsed_response['obj.idTitulo'][0]).to eql "JSON integer 12345678901 is too large or small for an Int32. Path 'obj.idTitulo', line 1, position 30." }
  end
end

describe 'Abrir Título' do
  context 'Abrir título de outro usuário' do
    before do
      idTitulo = build(:titulo).to_hash
      idTitulo[:idTitulo] = 89
      @result = ApiTitulos.post_open_titulo(@token, idTitulo)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Título não pertence ao usuário!' }
  end

  context 'Título ID passando maior de 10 inteiros' do
    before do
      idTitulo = build(:titulo).to_hash
      idTitulo[:idTitulo] = 12_345_678_901
      @result = ApiTitulos.post_open_titulo(@token, idTitulo)
    end

    it { expect(@result.parsed_response['obj.idTitulo'][0]).to eql "JSON integer 12345678901 is too large or small for an Int32. Path 'obj.idTitulo', line 1, position 30." }
  end
end

describe 'Buscar titulos nao abertos pelo usuario' do
  context 'Sucesso' do
    let(:result) { ApiTitulos.post_closed_titulo(@token) }
    it { expect(result.parsed_response['sucesso']).to be true }
  end
end

context 'Comprar com Cartao de Credito e verificar se o título foi atribuído' do
  before do
    TituloDB.new.delete_titulo_buy(@idUsuario)

    # Pagando o carrinho com cartao de credito
    cart = build(:cart).to_hash
    carrinho = ApiCart.post_add_item_cart(@token, cart)
    idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

    credit_card = build(:credit_card).to_hash
    ApiCartao.post_credit_card(@token, idCarrinho, credit_card)

    @total_titulos_user = TituloDB.new.select_get_amount_titulo(@idUsuario)
  end

  it { expect(@total_titulos_user['TOTAL']).to eql 1 }
end

context 'Comprar com crédito lottocap e verificar se o título foi atribuído' do
  before do
    CreditoLotto.new.update_creditoLottocap(100, @idUsuario)
    TituloDB.new.delete_titulo_buy(@idUsuario)

    # Pagando o carrinho com credito lottocap
    cart = build(:cart).to_hash
    carrinho = ApiCart.post_add_item_cart(@token, cart)
    idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

    credit = build(:payment_credit).to_hash
    @payment_credit = ApiCreditoLottocap.post_payment_credit_lottocap(@token, idCarrinho, credit)

    @total_titulos_user = TituloDB.new.select_get_amount_titulo(@idUsuario)
  end

  it { expect(@total_titulos_user['TOTAL']).to eql 1 }
end
