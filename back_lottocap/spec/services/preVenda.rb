# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiPreVenda
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'


  def self.get_exibirDezenas(token, idCarrinhoItem)
    headers['Authorization'] = token

    get("/Produto/ExibirDezenas/#{idCarrinhoItem}", body: @exibirDezenas.to_json)
  end
end

