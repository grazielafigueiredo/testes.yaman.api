# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiResultados
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.get_GetSeriesListResultados(token)
    headers[:Authorization] = token

    # get('Produto/GetSeriesListResultados', body: @GetSeriesListResultados.to_json)
    get('/Produto/GetSeriesListResultados')
  end

  def self.get_GetSerieResultados(token)
    headers[:Authorization] = token
        @GetSerieResultados = {
          "obj": {
            "idSerie": "91"
          }
        }
    post('/Produto/GetSerieResultados', body: @GetSerieResultados.to_json)
  end
end
