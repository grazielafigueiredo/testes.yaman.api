# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiResultados
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.get_seriesListResultados(token)
    headers[:Authorization] = token

    # get('Produto/GetSeriesListResultados', body: @GetSeriesListResultados.to_json)
    get('/Produto/getSeriesListResultados')
  end

  def self.get_serieResultados(token, idSerie)
    headers[:Authorization] = token
        @getSerieResultados = {
          "obj": {
            "idSerie": "#{idSerie}"
          }
        }
    post('/Produto/GetSerieResultados', body: @getSerieResultados.to_json)
  end
end
