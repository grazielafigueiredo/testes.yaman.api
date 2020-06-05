# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiRescue
  include HTTParty
  base_uri Constant::URI_HOMOLOG
  headers 'Content-Type' => 'application/json'

  def self.post_set_rescue(token, date_rescue)
    payload = { "obj": date_rescue }
    post('/Pagamento/SetResgate', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.get_status_rescue(token)
    get('/Usuario/GetDadosUsuarioParaResgate', headers: { 'Authorization' => token })
  end
end
