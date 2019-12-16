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
  context 'Abrindo MAX id86' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @tituloJa = ApiTitulos.post_GetTitulosNovos(@token)
      @idTitulo = JSON.parse(@tituloJa.response.body)['obj'][0]['novosTitulos'][0]['idTitulo']
      @result = ApiTitulos.post_VerificarPremioTitulo(@token, @idTitulo)
      ApiTitulos.post_AbrirTitulo(@token, @idTitulo)
      puts @idTitulo
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true}

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Abrindo JÁ 17' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      # Comprar JÁ 17
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProdutoJa, Constant::IdSerieJa, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
      
      # Abrir JÁ 17
      @tituloJa = ApiTitulos.post_GetTitulosNovos(@token)
      @idTitulo = JSON.parse(@tituloJa.response.body)['obj'][2]['novosTitulos'][0]['idTitulo']
      @result = ApiTitulos.post_VerificarPremioTitulo(@token, @idTitulo)
      @multiplicador = ApiTitulos.post_GetMultiplicador(@token, @idTitulo)
      puts @idTitulo
      puts @result
    
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true}

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Título outro usuário' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_VerificarPremioTitulo(@token, 89)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Este título não pertence ao usuário!" }

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

      @result = ApiTitulos.post_VerificarPremioTitulo(@token, 12345678901)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "JSON integer 12345678901 is too large or small for an Int32. Path 'obj.idTitulo', line 1, position 30."}

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

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Título não pertence ao usuário!" }

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

      @result = ApiTitulos.post_AbrirTitulo(@token, 12345678901)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "JSON integer 12345678901 is too large or small for an Int32. Path 'obj.idTitulo', line 1, position 30."}

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
    
    # @tituloAntesCompra = ApiTitulos.get_GetQtdTitulosUsuario(@token)   
    # puts ApiTitulos.get_GetQtdTitulosUsuario(@token)
    
    #Pagando o carrinho com cartao de credito
    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
    @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
    
    @titulo1 = ApiTitulos.get_GetQtdTitulosUsuario(@token)
    sleep 3
    puts ApiTitulos.get_GetQtdTitulosUsuario(@token)

    @compararTituloCompraComSelectBanco = (@titulo1 == Database.new.select_GetQtdTitulosUsuario())
    puts Database.new.select_GetQtdTitulosUsuario()
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

    #Atribuindo credito lottocap e pagando o carrinho
    @rs = Database.new.update_CreditoLottocap(100)
    puts @rs
    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
    @result = ApiCreditoLottocap.post_CreditoLottocap(@token, @idCarrinho)
    
    sleep 3
    @tituloDepoisCompra = ApiTitulos.get_GetQtdTitulosUsuario(@token)
    @tituloDepois = JSON.parse(@tituloDepoisCompra.response.body)['obj'][0]['qtd']

    @compararTituloCompraComSelectBanco = (@tituloDepois == Database.new.select_GetQtdTitulosUsuario())

  end
    # it { puts @tituloAntesCompra.response.body }
    # it { puts @tituloDepoisCompra.response.body }
    # # it { puts @result.response.body }
    # it { puts @compararTituloCompraComSelectBanco}
    # it { expect(@compararTituloCompraComSelectBanco).to be_truthy }
   it { puts @rs}

  after do
    Database.new.update_CreditoLottocap(0)
    ApiUser.get_deslogar(@token)
  end
end 
