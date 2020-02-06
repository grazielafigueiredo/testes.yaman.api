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
    expect(JSON.parse(@exibirDezenas.response.body)['dadosUsuario']['carrinhoItens'][0]['idCarrinhoItem']).to eql @idCarrinhoItem
    expect(JSON.parse(@exibirDezenas.response.body)['dadosUsuario']['carrinhoItens'][0]['flPreVenda']).to be true
    # expect(JSON.parse(@exibirDezenas.response.body)['obj'][0]['idDezenas']).to be_a Integer
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

    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(10, Constant::IdProduto, Constant::IdSerie, @token)
    @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
    @idCarrinhoItem = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinhoItem']
    puts @idCarrinhoItem

    @exibirDezenas = ApiPreVenda.get_exibirDezenas(@token, @idCarrinhoItem)
    # conjuntos = JSON.parse(@exibirDezenas.response.body)['obj']
    puts @exibirDezenas
  end

  it 'não exibirDezenas' do
    expect(JSON.parse(@exibirDezenas.response.body)['obj']).to eql []
    expect(JSON.parse(@exibirDezenas.response.body)['dadosUsuario']['carrinhoItens'][0]['flPreVenda']).to eql false
  end

  after do
    ApiUser.get_deslogar(@token)
  end
end

context 'Colocar no carrinho Título já reservado' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    @preVenda = ApiPreVenda.post_adicionarItemCarrinhoPreVenda(1, Constant::IdProduto, Constant::IdSerieMaxPreVenda, @token)
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

# context 'Concorrencia no pagamento Título já reservado' do
#   before do
#     @token = ApiUser.GetToken
#     ApiUser.Login(@token, Constant::User1)

#       @buscarDezenas = ApiPreVenda.post_buscarDezenas(@token, @idCarrinhoItem)
#       @conjuntosDezenas = JSON.parse(@buscarDezenas.response.body)['obj']


#       @preVenda = ApiPreVenda.post_adicionarItemCarrinhoPreVenda(@conjuntosDezenas, @token)
#       @idCarrinhoUser1 = JSON.parse(@preVenda.response.body)['obj'][0]['idCarrinho']
#       puts @preVenda1

      
#     @token = ApiUser.GetToken
#     ApiUser.Login(@token, Constant::User2)
      
#       @buscarDezenas = ApiPreVenda.post_buscarDezenas(@token, @idCarrinhoItem)
#       @conjuntosDezenas = JSON.parse(@buscarDezenas.response.body)['obj']
      
#       @preVenda = ApiPreVenda.post_adicionarItemCarrinhoPreVenda(@conjuntosDezenas, @token)
#       @idCarrinhoUser2 = JSON.parse(@preVenda.response.body)['obj'][0]['idCarrinho']
#       puts @preVenda
      
#       @boleto = ApiBoleto.post_sucessoBoleto(@token, @idCarrinhoUser1)
#       @boleto = ApiBoleto.post_sucessoBoleto(@token, @idCarrinhoUser2)
#   end

#   it 'Comprar um Título reservado' do
#     expect(JSON.parse(@preVenda.response.body)['sucesso']).to eql false
#     expect(JSON.parse(@preVenda.response.body)['erros'][0]['mensagem']).to eql "Não foi possível adicionar o título escolhido ao carrinho."
#   end

#   after do
#     ApiUser.get_deslogar(@token)
#   end
# end