
context 'Loop' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

      900.times do
        @tituloJa = ApiTitulos.post_GetTitulosNovos(@token)
        @idTitulo = JSON.parse(@tituloJa.response.body)['obj'][0]['novosTitulos'][0]['idTitulo']
        @result = ApiTitulos.post_VerificarPremioTitulo(@token, @idTitulo)
        ApiTitulos.post_AbrirTitulo(@token, @idTitulo)
        puts @idTitulo
        puts @result
      end
  end

  it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

  after do
    ApiUser.get_deslogar(@token)
  end
end

context 'loops' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    Database.new.update_DataFinalVendaVigente('2020-12-25')

    carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
    @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

    @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)

    @tituloJa = ApiTitulos.post_GetTitulosNovos(@token)
    idTitulo = expect(JSON.parse(@tituloJa.response.body)['obj'][0]['novosTitulos'][0]['idTitulo']).to be_a Integer

    while idTitulo # variável para rodar o loop, enqto a variável retornar Integer

      @tituloJa = ApiTitulos.post_GetTitulosNovos(@token)
      @idTitulo = JSON.parse(@tituloJa.response.body)['obj'][0]['novosTitulos'][0]['idTitulo']
      @result = ApiTitulos.post_VerificarPremioTitulo(@token, @idTitulo)

      ApiTitulos.post_AbrirTitulo(@token, @idTitulo)
      puts @result
      puts @idTitulo

    end
  end

  it {
    expect(JSON.parse(@result.response.body)['sucesso']).to be true
  }

  after do
    ApiUser.get_deslogar(@token)
  end
end
