# frozen_string_literal: true

context 'Validar se há dezenas repetidas' do
  before do
    @token = ApiUser.GetToken

    # Pre_vendaDB.new.update_pre_venda

    @cart = build(:cart).to_hash
    @cart[:qtdItens] = 10
    @cart[:idSerie] = Constant::IdSerieMaxPreVenda
    @carrinho = ApiCart.post_add_item_cart(@token, @cart)
    @idCarrinhoItem = @carrinho.parsed_response['obj'][0]['idCarrinhoItem']

    @show_dezenas = ApiPreVenda.get_show_dezenas(@token, @idCarrinhoItem)
    conjuntos = (@show_dezenas.parsed_response)['obj']
    puts @show_dezenas

    def obtem_conjuntos_repetidos(conjuntos)
      conjuntos_repetidos = {}

      conjuntos.each do |conjunto_atual|
        repetiu = 0
        dezenas_atual = conjunto_atual['dezenas'].split(' ').sort

        conjuntos.each do |conjunto_comparando|
          dezenas_comparando = conjunto_comparando['dezenas'].split(' ').sort

          repetiu += 1 if dezenas_atual == dezenas_comparando
        end

        conjuntos_repetidos[dezenas_atual.join(' ')] = repetiu if repetiu >= 2
      end

      conjuntos_repetidos
    end
    resultado = obtem_conjuntos_repetidos(conjuntos)

    puts "\nResultado de conjuntos repetidos:"
    puts resultado
  end

  it 'exibirDezenas' do
    expect((@show_dezenas.parsed_response)['obj'][0]['idDezenas']).to be_a Integer
    expect((@show_dezenas.parsed_response)['obj'][0]['dezenas']).to be_a String
    expect((@show_dezenas.parsed_response)['sucesso']).to be true
  end
end

context 'Quando a série não estiver em pre venda, então o contrato do endpoint não pode exibir conjunto de dezenas' do
  before do
    @token = ApiUser.GetToken

    @cart = build(:cart).to_hash
    @cart[:qtdItens] = 10
    @carrinho = ApiCart.post_add_item_cart(@token, @cart)
    @idCarrinhoItem = @carrinho.parsed_response['obj'][0]['idCarrinhoItem']

    @show_dezenas = ApiPreVenda.get_show_dezenas(@token, @idCarrinhoItem)
  end

  it 'Quando a série não estiver em pre venda, então o contrato do endpoint não pode exibir conjunto de dezenas' do
    expect((@show_dezenas.parsed_response)['obj']).to eql []
  end
end

context 'Adicionar ao carrinho conjunto de dezenas que já foi reservado/comprado' do
  before do
    Pre_vendaDB.new.update_reservar_titulo
    @token = ApiUser.GetToken
    @cart = build(:cart_dezenas).to_hash
    @preVenda = ApiPreVenda.post_add_item_cart_prevenda(@token, @cart)
  end

  it 'Adicionar ao carrinho conjunto de dezenas que já foi reservado/comprado' do
    expect((@preVenda.parsed_response)['sucesso']).to eql false
    expect((@preVenda.parsed_response)['erros'][0]['mensagem']).to eql 'Não foi possível adicionar o título escolhido ao carrinho.'
  end
end

context 'Concorrencia no pagamento Título já reservado' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    @dezenas = build(:search_dezenas).to_hash
    @search_dezenas = ApiPreVenda.post_search_dezenas(@token, @dezenas)
    @group_dezenas = (@search_dezenas.parsed_response)['obj'][0]

    @cart = build(:cart_dezenas).to_hash
    @cart[:lstDezenas] = [@group_dezenas]
    @cart_pre = ApiPreVenda.post_add_item_cart_prevenda(@token, @cart)
    @id_cart = (@cart_pre.parsed_response)['obj'][0]['idCarrinho']

    Pre_vendaDB.new.update_reservar_group_dezenas(@group_dezenas)

    @payment_cart = build(:credit_card).to_hash
    @result = ApiCartao.post_credit_card(@token, @id_cart, @payment_cart)
  end

  it 'Pagar conjunto de dezenas que já foi reservado/comprado' do
    expect((@result.parsed_response)['sucesso']).to eql false
    expect((@result.parsed_response)['erros'][0]['mensagem']).to eql "Reserva de titulos já foi solicitada para as dezenas #{@group_dezenas}"
  end

  after do
    ApiUser.get_logout(@token)
  end
end
