# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiResultados
  include HTTParty
  base_uri Constant::Url
    # base_uri "https://hmlapi2.lottocap.com.br/api/"
  headers 'Content-Type' => 'application/json'

  def self.get_GetSeriesListResultados(token)
    headers[:Authorization] = token

    # get('Produto/GetSeriesListResultados', body: @GetSeriesListResultados.to_json)
    get('/Produto/GetSeriesListResultados')
  end
end
