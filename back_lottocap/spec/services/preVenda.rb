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

  def self.post_buscarDezenas(token)
    headers['Authorization'] = token

    @buscarDezenas = {
      "obj": {
        "dezenas": ["01", "02"],
        "idSerie": Constant::IdSerieMaxPreVenda
      }
    }

    post("/Produto/BuscarDezenas", body: @buscarDezenas.to_json)
  end

  def self.post_adicionarItemCarrinhoPreVenda(conjuntosDezenas, token)
    headers['Authorization'] = token

    @adicionarItemCarrinhoPreVenda = {
      "obj": {
        "idSerie": Constant::IdSerieMaxPreVenda,
        "lstDezenas": ["conjuntosDezenas"],
        "flPromoAtiva": false
      },
      "atualPagina": 1,
      "tamanhoPagina": 999
    }
    post("/Carrinho/AdicionarItemCarrinhoPreVenda", body: @adicionarItemCarrinhoPreVenda.to_json)
  end
end

