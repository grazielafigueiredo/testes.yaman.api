# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiRanking
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.get_rankingResultados(token)
    headers[:Authorization] = token

    get('/Produto/GetRankingResultados')
  end

  def self.post_rankingResultadosPorSerie(token)
    headers[:Authorization] = token
    @resultadosPorSerie = {
      "obj": {
        "idSerie": "#{Constant::IdSerieMaxRegular}"
      }
    }

    post('/Produto/GetRankingResultadosPorSerie', body: @resultadosPorSerie.to_json)
  end

  def self.get_modalPremiado(token)
    headers[:Authorization] = token

    get("/Produto/GetModalPremiado?idSerie=#{Constant::IdSerieMaxRegular}&nmTituloFixo=2550&qtdPontos=15")
  end

  def self.get_sorteiosResultados(token)
    headers[:Authorization] = token

    get("/Produto/GetSorteiosResultados?idSerie=#{Constant::IdSerieMaxRegular}")
  end

  def self.get_modalRankingPorPontos(token)
    headers[:Authorization] = token

    get("/Produto/GetModalRankingPorPontos?idSerie=#{Constant::IdSerieMaxRegular}&qtdPontos=15")
  end
end
