# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiPreVenda
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json', 'Authorization' => ApiUser.GetToken

  def self.get_show_dezenas(token, idCarrinhoItem)
    get("/Produto/ExibirDezenas/#{idCarrinhoItem}", headers: { 'Authorization' => token })
  end

  def self.post_search_dezenas(token, dezenas)
    payload = { "obj": dezenas }
    post('/Produto/BuscarDezenas', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.post_add_item_cart_prevenda(token, cart)
    payload = { "obj": cart }
    post('/Carrinho/AdicionarItemCarrinhoPreVenda', body: payload.to_json, headers: { 'Authorization' => token })
  end
end
