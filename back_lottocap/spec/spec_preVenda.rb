# frozen_string_literal: true

context 'Config pré-venda' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    Database.new.update_preVenda

    @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerieMaxPreVenda, @token)
        @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
        @idCarrinhoItem = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinhoItem']
    puts @idCarrinhoItem

    @exibirDezenas = ApiPreVenda.get_exibirDezenas(@token, @idCarrinhoItem)
    puts @exibirDezenas
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
