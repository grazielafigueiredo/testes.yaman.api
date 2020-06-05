# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiRanking
  include HTTParty
  base_uri Constant::URIPROD
  headers 'Content-Type' => 'application/json'

  def self.get_rankingResultados(token)
    get('/Produto/GetRankingResultados?offset=1', headers: { 'Authorization' => token })
  end

  def self.post_rankingResultadosPorSerie(token, idSerie)
    payload = {
      "obj": {
        "idSerie": idSerie.to_s,
        "offset": 1
      }
    }
    post('/Produto/GetRankingResultadosPorSerie', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.get_modalPremiado(token, idSerie)
    get("/Produto/GetModalPremiado?idSerie=#{idSerie}&nmTituloFixo=2550&qtdPontos=15&offset=1", headers: { 'Authorization' => token })
  end

  def self.get_sorteiosResultados(token, idSerie)
    get("/Produto/GetSorteiosResultados?idSerie=#{idSerie}&offset=1", headers: { 'Authorization' => token })
  end

  def self.get_modalRankingPorPontos(token, idSerie)
    get("/Produto/GetModalRankingPorPontos?idSerie=#{idSerie}&qtdPontos=15&offset=1", headers: { 'Authorization' => token })
  end
end
