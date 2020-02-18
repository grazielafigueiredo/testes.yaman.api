# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiResultados
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.get_getSeriesListResultados(token)
    headers[:Authorization] = token

    # get('Produto/GetSeriesListResultados', body: @GetSeriesListResultados.to_json)
    get('/Produto/getSeriesListResultados')
  end

  def self.get_getSerieResultados(token)
    headers[:Authorization] = token
        @getSerieResultados = {
          "obj": {
            "idSerie": "91"
          }
        }
    post('/Produto/GetSerieResultados', body: @getSerieResultados.to_json)
  end
end
