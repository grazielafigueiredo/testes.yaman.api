# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiCart
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json', 'Authorization' => ApiUser.GetToken

  def self.get_status_cart(token)
    get('/Carrinho/GetStatusCarrinho', headers: { 'Authorization' => token })
  end

  def self.post_set_qtd_item_carrinho(token)
    payload = { "obj": {
      "novaQtdItem": 299,
      "idSerie": Constant::IdSerieMaxRegular,
      "flPromoAtiva": false
    }}
    post('/Carrinho/SetQtdItemCarrinho', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.post_set_remover_item_cart(token, cart)
    payload = { "obj": cart }

    # @SetRemoverItemCarrinho = {
    #   "obj": {
    #     "idCarrinhoItem": idCarrinhoItem,
    #     "flPromoAtiva": false
    #   },
    #   "atualPagina": 1,
    #   "tamanhoPagina": 999
    # }
    post('/Carrinho/SetRemoverItemCarrinho', body: payload.to_json, headers: { 'Authorization' => token })
  end
  
  def self.post_add_item_cart(token, cart)
    payload = { "obj": cart }
    post('/Carrinho/AdicionarItemCarrinho', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.post_add_item_cart_afiliados(token, cart)
    payload = { "obj": cart }
    post('/Carrinho/AdicionarItemCarrinhoAfiliados', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.post_cart_itens(token)
    payload = { "obj": { "flPromoAtiva": false } }
    post('/Carrinho/GetCarrinhoItens', body: payload.to_json, headers: { 'Authorization' => token })
  end
  def self.get_product_vitrine(token)
    get('/Produto/PesquisarProdutosDisponiveis', headers: { 'Authorization' => token })
  end
end
