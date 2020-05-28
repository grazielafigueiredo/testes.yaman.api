# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiRescue
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.post_set_rescue(token, date_rescue)
    headers['Authorization'] = token
    payload = { "obj": date_rescue }
    post('/Pagamento/SetResgate', body: payload.to_json)
  end

  def self.get_status_rescue(token)
    headers['Authorization'] = token
    get('/Usuario/GetDadosUsuarioParaResgate')
  end
end
