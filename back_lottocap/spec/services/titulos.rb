# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiTitulos
  include HTTParty
  base_uri 'https://hmlapi.lottocap.com.br/api'
  headers 'Content-Type' => 'application/json'


  def self.post_BuscarTitulosAgrupadosPorSerie(token)
    headers['Authorization'] = token

    @titulosAgrupados = {
        "obj": {},
        "tamanhoPagina": 9999,
        "atualPagina": 1
    }
    post('/Usuario/BuscarTitulosAgrupadosPorSerie', body: @titulosAgrupados.to_json)
  end

  def self.post_GetTitulosNovos(token)
    headers['Authorization'] = token

    @GetTitulosNovos = {
        "obj": {}
    }
    post('/Usuario/GetTitulosNovos', body: @GetTitulosNovos.to_json)
  end

  def self.post_VerificarPremioTitulo(token, idTitulo)
    headers['Authorization'] = token

    @VerificarPremioTitulo = {
      "obj": {
        "idTitulo": idTitulo
      }
    }
    post('/Usuario/VerificarPremioTitulo', body: @VerificarPremioTitulo.to_json)
  end
end

