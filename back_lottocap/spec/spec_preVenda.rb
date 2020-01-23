# frozen_string_literal: true

context 'Config pré-venda' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    Database.new.update_preVenda

    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(10, Constant::IdProduto, Constant::IdSerieMaxPreVenda, @token)
        @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
        @idCarrinhoItem = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinhoItem']
    puts @idCarrinhoItem

    @exibirDezenas = ApiPreVenda.get_exibirDezenas(@token, @idCarrinhoItem)
    conjuntos = JSON.parse(@exibirDezenas.response.body)['obj']
    puts @exibirDezenas
    
    def obtem_conjuntos_repetidos(conjuntos)
    conjuntos_repetidos = {}
    
      for conjunto_atual in conjuntos
        repetiu = 0
        dezenas_atual = conjunto_atual['dezenas'].split(' ').sort
        
        for conjunto_comparando in conjuntos
          
          dezenas_comparando = conjunto_comparando['dezenas'].split(' ').sort
    
          if dezenas_atual == dezenas_comparando
            repetiu += 1
          end
        end
    
        if repetiu >=2
          conjuntos_repetidos[dezenas_atual.join(' ')] = repetiu
        end
      end
      
      return conjuntos_repetidos
    end
    resultado = obtem_conjuntos_repetidos(conjuntos)
  
    puts "\nResultado de conjuntos repetidos:"
    puts resultado
  end

  it 'exibirDezenas' do
    expect(JSON.parse(@exibirDezenas.response.body)['dadosUsuario']['carrinhoItens'][0]['idCarrinhoItem']).to eql @idCarrinhoItem
    expect(JSON.parse(@exibirDezenas.response.body)['dadosUsuario']['carrinhoItens'][0]['flPreVenda']).to be true
    expect(JSON.parse(@exibirDezenas.response.body)['obj'][0]['idDezenas']).to be_a Integer
    expect(JSON.parse(@exibirDezenas.response.body)['obj'][0]['dezenas']).to be_a String
    expect(JSON.parse(@exibirDezenas.response.body)['sucesso']).to be true

  end

  after do
    ApiUser.get_deslogar(@token)
  end
end

