# frozen_string_literal: true

describe 'Títulos' do
  context 'Agrupador por série' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_BuscarTitulosAgrupadosPorSerie(@token)
    end
    sleep 5
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    # it { puts @token }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Títulos novos' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_GetTitulosNovos(@token)
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end


describe 'Verificar Premio Titulo' do
  context 'Sucesso' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_VerificarPremioTitulo(@token, Constant::IdTitulo)
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true}
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Título outro usuário' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_VerificarPremioTitulo(@token, 89)
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Este título não pertence ao usuário!" }
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  # context 'Título Null' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)

  #     @result = ApiTitulos.post_VerificarPremioTitulo(@token, nil)
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

      @result = ApiTitulos.post_VerificarPremioTitulo(@token, 12345678901)
    end

    it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "JSON integer 12345678901 is too large or small for an Int32. Path 'obj.idTitulo', line 1, position 30."}
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end



describe 'Abrir Título' do

  context 'Sucesso' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_AbrirTitulo(@token, Constant::IdTitulo)
      @titulos = ApiTitulos.get_GetQtdTitulosUsuario(@token)
      @getTitulos1 = JSON.parse(@titulos.response.body)['obj'][0]['qtd']
    
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true}
    it { puts @result.response.body }
    it { puts @titulos.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Título outro usuário' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_AbrirTitulo(@token, 89)
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Título não pertence ao usuário!" }
    it { puts @result.response.body }

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
    end

    it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "JSON integer 12345678901 is too large or small for an Int32. Path 'obj.idTitulo', line 1, position 30."}
    it { puts @result.response.body }

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
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'GetMultiplicador' do
  context 'Sucesso' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_GetMultiplicador(@token)
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end


context 'Comprar com Cartao de Credito e verificar se o título foi atribuído' do 
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)
    
    @tituloAntesCompra = ApiTitulos.get_GetQtdTitulosUsuario(@token)   
    
    #Pagando o carrinho com cartao de credito
    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
    @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
    
    sleep 3
    @tituloDepoisCompra = ApiTitulos.get_GetQtdTitulosUsuario(@token)
    @tituloDepois = JSON.parse(@titulos.response.body)['obj'][0]['qtd']

    @compararTituloCompraComSelectBanco = (@tituloDepois == Database.new.select_GetQtdTitulosUsuario())

  end
    # it { expect(JSON.parse(@titulos1.response.body)['obj'][0]['qtd']).to be != @getTitulos}
    # it { puts @tituloAntesCompra.response.body }
    # it { puts @tituloDepoisCompra.response.body }
    # it { puts @result.response.body }
    it { puts @compararTituloCompraComSelectBanco}
    it { expect(@compararTituloCompraComSelectBanco).to be_truthy }
    # it { puts @carrinho.response.body }
    # it { puts @result.response.body }

  after do
    ApiUser.get_deslogar(@token)
  end
end 


context 'Comprar com CLottocap e verificar se o título foi atribuído' do 
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)
    
    @titulos = ApiTitulos.get_GetQtdTitulosUsuario(@token)   
    @getTitulos = JSON.parse(@titulos.response.body)['obj'][0]['qtd']
    
    #Atribuindo credito lottocap e pagando o carrinho
    Database.new.update_CreditoLottocap(100.000)
    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
    @result = ApiCreditoLottocap.post_CreditoLottocap(@token, @idCarrinho)
    
    sleep 3
    @titulos1 = ApiTitulos.get_GetQtdTitulosUsuario(@token)
    @getTitulos1 = JSON.parse(@titulos.response.body)['obj'][0]['qtd']
   
    # @soma = (@getTitulos != @getTitulos1 )
  end
    # it { expect(JSON.parse(@titulos1.response.body)['obj'][0]['qtd']).to be @getTitulos}
    # it { puts @titulos.response.body }
    # it { puts @titulos1.response.body }
    # # it { expect(@soma).to be_truthy }
    # it { puts @result.response.body }
    it { puts @carrinho.response.body }
    it { puts @result.response.body }

  after do
    Database.new.update_CreditoLottocap(0.000)
    ApiUser.get_deslogar(@token)
  end
end 
