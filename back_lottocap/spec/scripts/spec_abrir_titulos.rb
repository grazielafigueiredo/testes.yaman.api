
context 'Loop' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, build(:login).to_hash)

      900.times do
        tituloJa = ApiTitulos.post_get_new_titulo(@token)
        puts tituloJa
        idTitulo = (tituloJa.parsed_response)['obj'][0]['novosTitulos'][0]['idTitulo']
        titulo = build(:titulo).to_hash
        titulo[:idTitulo] = idTitulo
        @result = ApiTitulos.post_premium_titulo(@token, titulo)

        titulo = build(:titulo).to_hash
        titulo[:idTitulo] = idTitulo
        ApiTitulos.post_open_titulo(@token, titulo)
      end
  end

  it { expect((@result.parsed_response)['sucesso']).to be true }

  after do
    ApiUser.get_logout(@token)
  end
end

context 'loops' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, build(:login).to_hash)

    cart = build(:cart).to_hash
    carrinho = ApiCart.post_add_item_cart(@token, cart)
    idCarrinho = (carrinho.parsed_response)['obj'][0]['idCarrinho']

    credit_card = build(:credit_card).to_hash
    @result = ApiCartao.post_credit_card(@token, idCarrinho, credit_card)

    tituloJa = ApiTitulos.post_get_new_titulo(@token)
    idTitulo = expect((tituloJa.parsed_response)['obj'][0]['novosTitulos'][0]['idTitulo']).to be_a Integer

    while idTitulo # variável para rodar o loop, enqto a variável retornar Integer

      tituloJa = ApiTitulos.post_get_new_titulo(@token)
      idTitulo = (tituloJa.parsed_response)['obj'][0]['novosTitulos'][0]['idTitulo']
      titulo = build(:titulo).to_hash
      titulo[:idTitulo] = idTitulo
      @result = ApiTitulos.post_premium_titulo(@token, titulo)

      titulo = build(:titulo).to_hash
      titulo[:idTitulo] = idTitulo
      ApiTitulos.post_open_titulo(@token, titulo)
    end
  end

  it { expect((@result.parsed_response)['sucesso']).to be true }

  after do
    ApiUser.get_logout(@token)
  end
end
