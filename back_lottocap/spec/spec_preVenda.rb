# frozen_string_literal: true

context 'Config pré-venda' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    PreVenda.new.update_preVenda

    @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
      10, 
      Constant::IdProduto, 
      Constant::IdSerieMaxPreVenda, 
      @token
    )

    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
    @idCarrinhoItem = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinhoItem']
    # puts @idCarrinhoItem

    @exibirDezenas = ApiPreVenda.get_exibirDezenas(@token, @idCarrinhoItem)
    conjuntos = JSON.parse(@exibirDezenas.response.body)['obj']
    puts @exibirDezenas

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
    expect(JSON.parse(@exibirDezenas.response.body)['obj'][0]['idDezenas']).to be_a Integer
    expect(JSON.parse(@exibirDezenas.response.body)['obj'][0]['dezenas']).to be_a String
    expect(JSON.parse(@exibirDezenas.response.body)['sucesso']).to be true
  end

  after do
    ApiUser.get_deslogar(@token)
  end
end

context 'escolha de dezenas nao pode trazer qndo a série nao estiver em pré venda' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
      10, 
      Constant::IdProduto, 
      Constant::IdSerie, 
      @token
    )
     puts @token                                                  
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
    @idCarrinhoItem = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinhoItem']
    puts @idCarrinhoItem

    @exibirDezenas = ApiPreVenda.get_exibirDezenas(@token, @idCarrinhoItem)

    puts @exibirDezenas
  end

  it 'não exibirDezenas' do
    expect(JSON.parse(@exibirDezenas.response.body)['obj']).to eql []
  end

  after do
    ApiUser.get_deslogar(@token)
  end
end

context 'Colocar no carrinho Título já reservado' do
  before do
    PreVenda.new.update_reservar_titulo
    
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)


    @preVenda = ApiPreVenda.post_adicionarItemCarrinhoPreVenda(@token, ["01 02 03"])
    puts @preVenda
  end

  it 'Comprar um Título reservado' do
    expect(JSON.parse(@preVenda.response.body)['sucesso']).to eql false
    expect(JSON.parse(@preVenda.response.body)['erros'][0]['mensagem']).to eql "Não foi possível adicionar o título escolhido ao carrinho."
  end

  after do
    ApiUser.get_deslogar(@token)
  end
end

context 'Concorrencia no pagamento Título já reservado' do
  before do
    @token1 = ApiUser.GetToken
    ApiUser.Login(@token1, Constant::User1)
    
    @buscarDezenas = ApiPreVenda.post_buscarDezenas(@token1)
    @conjuntosDezenas = JSON.parse(@buscarDezenas.response.body)['obj'][0]
    puts @conjuntosDezenas

    @lstDezenas = ApiPreVenda.post_adicionarItemCarrinhoPreVenda(@token1, [@conjuntosDezenas])
    @idCarrinhoUser1 = JSON.parse(@lstDezenas.response.body)['obj'][0]['idCarrinho']
      
    @token2 = ApiUser.GetToken
    ApiUser.Login(@token2, Constant::User2)

    @lstDezenas = ApiPreVenda.post_adicionarItemCarrinhoPreVenda(@token2, [@conjuntosDezenas])
    @idCarrinhoUser2 = JSON.parse(@lstDezenas.response.body)['obj'][0]['idCarrinho']
    puts @lstDezenas

      @pagarCarrinho1 = ApiCartao.post_PagarCartaoDeCredito(
        @token1,
        @idCarrinhoUser1,
        Constant::NomeCompletoTitular,
        Constant::NumeroCartao,
        Constant::ValidadeMesCartao,
        Constant::ValidadeAnoCartao,
        Constant::CartaoCVV
      )
      puts @pagarCarrinho1

      @pagarCarrinho2 = ApiCartao.post_PagarCartaoDeCredito(
        @token2,
        @idCarrinhoUser2,
        Constant::NomeCompletoTitular,
        Constant::NumeroCartao,
        Constant::ValidadeMesCartao,
        Constant::ValidadeAnoCartao,
        Constant::CartaoCVV
      )
      puts @pagarCarrinho2

  end

  it 'Concorrencia no pagamento Título já reservado' do
    expect(JSON.parse(@pagarCarrinho2.response.body)['sucesso']).to eql false
    expect(JSON.parse(@pagarCarrinho2.response.body)['erros'][0]['mensagem']).to eql "Reserva de titulos já foi solicitada para as dezenas #{@conjuntosDezenas}"
  end

  after do
    ApiUser.get_deslogar(@token)
  end
end