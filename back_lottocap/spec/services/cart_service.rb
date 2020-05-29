# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiCart
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json', 'Authorization' => ApiUser.GetToken

  def self.get_GetStatusCarrinho
    get('/Carrinho/GetStatusCarrinho')
  end

  def self.post_SetQtdItemCarrinho(qtdItens, token, idSerie)

    @SetQtdItemCarrinho = { "obj": {
      "novaQtdItem": qtdItens,
      "idSerie": idSerie,
      "flPromoAtiva": false
    },
                            "atualPagina": 1,
                            "tamanhoPagina": 999 }
    post('/Carrinho/SetQtdItemCarrinho', body: @SetQtdItemCarrinho.to_json, headers: { 'Authorization' => token })
  end

  def self.post_add_item_cart(token, cart)
    payload = { "obj": cart }
    post('/Carrinho/AdicionarItemCarrinho', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.post_set_remover_item_cart(token, idCarrinho)

    @SetRemoverItemCarrinho = {
      "obj": {
        "idCarrinhoItem": idCarrinho,
        "flPromoAtiva": false
      },
      "atualPagina": 1,
      "tamanhoPagina": 999
    }
    post('/Carrinho/SetRemoverItemCarrinho', body: @SetRemoverItemCarrinho.to_json, headers: { 'Authorization' => token })
  end

  def self.post_adicionarItemCarrinhoAfiliados(token, idProduto, idSerie87, qtdItens)

    @adicionarItemCarrinhoAfiliados =
      {
        "obj": {
          "idCarrinho": 0,
          "idProduto": idProduto, # neste endpoint o front ignora a id série
          "idSerie": idSerie87,
          "qtdItens": qtdItens,
          "flPromoAtiva": false
        },
        "atualPagina": 1,
        "tamanhoPagina": 999
      }
    post('/Carrinho/AdicionarItemCarrinhoAfiliados', body: @adicionarItemCarrinhoAfiliados.to_json, headers: { 'Authorization' => token })
  end

  def self.post_GetCarrinhoItens(token)

    @GetCarrinhoItens = {
      "obj": {
        "flPromoAtiva": false
      }
    }
    post('Carrinho/GetCarrinhoItens', body: @GetCarrinhoItens.to_json, headers: { 'Authorization' => token })
  end
end
