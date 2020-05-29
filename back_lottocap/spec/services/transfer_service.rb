# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiTransfer
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.post_transfer(token, idCarrinho, transfer)
    # headers['Authorization'] = token
    transfer[:idCarrinho] = idCarrinho
    payload = { "obj": transfer }
    post('/Pagamento/PagarCarrinho', body: payload.to_json, headers: { 'Authorization' => token })
  end
end
