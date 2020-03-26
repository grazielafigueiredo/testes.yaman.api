# frozen_string_literal: true

describe 'Títulos' do
  context 'Agrupador por série' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_BuscarTitulosAgrupadosPorSerie(@token)
      puts @result
    end
    sleep 5
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Títulos novos' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_GetTitulosNovos(@token)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'Verificar Premio Titulo' do
  context 'Título outro usuário' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_VerificarPremioTitulo(@token, 89)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Este título não pertence ao usuário!' }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  # context 'Título Null' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)

  #     @result = ApiTitulos.post_VerificarPremioTitulo(@token, nil)
  #     puts @result
  #     end

  #   it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "Unexpected character encountered while parsing value: }. Path 'obj.idTitulo', line 4, position 2."}

  #   after do
  #     ApiUser.get_deslogar(@token)
  #   end
  # end

  context 'Título ID passando maior de 10 inteiros' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_VerificarPremioTitulo(@token, 12_345_678_901)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "JSON integer 12345678901 is too large or small for an Int32. Path 'obj.idTitulo', line 1, position 30." }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'Abrir Título' do
  context 'Título outro usuário' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_AbrirTitulo(@token, 89)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Título não pertence ao usuário!' }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  # context 'Título Null' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)

  #     @result = ApiTitulos.post_AbrirTitulo(@token, nil)
  #   end

  #   it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "Unexpected character encountered while parsing value: }. Path 'obj.idTitulo', line 4, position 2."}
  #   it { puts @result.response.body }

  #   after do
  #     ApiUser.get_deslogar(@token)
  #   end
  # end

  context 'Título ID passando maior de 10 inteiros' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_AbrirTitulo(@token, 12_345_678_901)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "JSON integer 12345678901 is too large or small for an Int32. Path 'obj.idTitulo', line 1, position 30." }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'BuscarTitulosNaoAbertosUsuario' do
  context 'Sucesso' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_BuscarTitulosNaoAbertosUsuario(@token)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end

context 'Comprar com Cartao de Credito e verificar se o título foi atribuído' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    @tituloAntesCompra = ApiTitulos.get_GetQtdTitulosUsuario(@token)['obj'][0]['qtd']
    puts('tituloAntesCompra', @tituloAntesCompra)

    # Pagando o carrinho com cartao de credito
    @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
      1,
      Constant::IdProduto,
      Constant::IdSerieMaxRegular,
      @token
    )
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
    @result = ApiCartao.post_PagarCartaoDeCredito(
      @token,
      @idCarrinho,
      'CARLOS',
      '5521884306233764',
      '11',
      Constant::ValidadeAnoCartao,
      '123'
    )

    @tituloDepoisCompra = ApiTitulos.get_GetQtdTitulosUsuario(@token)['obj'][0]['qtd']
    puts('tituloDepoisCompra', @tituloDepoisCompra)

    @tituloDentroDoBanco = Database.new.select_GetQtdTitulosUsuario.first['TOTAL']
    puts('tituloDentroDoBanco', @tituloDentroDoBanco)

    @compararTituloCompraComSelectBanco = (@tituloDepoisCompra == @tituloDentroDoBanco)
  end

  it { expect(@compararTituloCompraComSelectBanco).to be_truthy }

  after do
    ApiUser.get_deslogar(@token)
  end
end

context 'Comprar com CLottocap e verificar se o título foi atribuído' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    @tituloAntesCompra = ApiTitulos.get_GetQtdTitulosUsuario(@token)

    # Atribuindo credito lottocap e pagando o carrinho
    @rs = CreditoLotto.new.update_creditoLottocap(100)
    puts @rs
    @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
      2,
      Constant::IdProduto,
      Constant::IdSerieMaxRegular,
      @token
    )
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
    @result = ApiCreditoLottocap.post_pagarCarrinhoComCreditoLottocap(@token, @idCarrinho)

    sleep 3
    @tituloDepoisCompra = ApiTitulos.get_GetQtdTitulosUsuario(@token)
    @tituloDepois = JSON.parse(@tituloDepoisCompra.response.body)['obj'][0]['qtd']

    @compararTituloCompraComSelectBanco = (@tituloDepois == Database.new.select_GetQtdTitulosUsuario)
  end
  # it { puts @tituloAntesCompra.response.body }
  # it { puts @tituloDepoisCompra.response.body }
  # # it { puts @result.response.body }
  # it { puts @compararTituloCompraComSelectBanco}
  # it { expect(@compararTituloCompraComSelectBanco).to be_truthy }
  it { puts @rs }

  after do
    CreditoLotto.new.update_creditoLottocap(0)
    ApiUser.get_deslogar(@token)
  end
end
