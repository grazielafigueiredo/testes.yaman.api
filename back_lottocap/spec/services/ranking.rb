# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiRanking
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json', 'Authorization' => ApiUser.GetToken

  def self.get_rankingResultados
    get('/Produto/GetRankingResultados?offset=1')
  end

  def self.post_rankingResultadosPorSerie
    @resultadosPorSerie = {
      "obj": {
        "idSerie": Constant::IdSerieMaxRegular.to_s
      }
    }
    post('/Produto/GetRankingResultadosPorSerie?offset=1', body: @resultadosPorSerie.to_json)
  end

  def self.get_modalPremiado
    get("/Produto/GetModalPremiado?idSerie=#{Constant::IdSerieMaxRegular}&nmTituloFixo=2550&qtdPontos=15&offset=1")
  end

  def self.get_sorteiosResultados
    get("/Produto/GetSorteiosResultados?idSerie=#{Constant::IdSerieMaxRegular}&offset=1")
  end

  def self.get_modalRankingPorPontos
    get("/Produto/GetModalRankingPorPontos?idSerie=#{Constant::IdSerieMaxRegular}&qtdPontos=15&offset=1")
  end
end
