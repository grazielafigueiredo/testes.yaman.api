# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiTransfer
  include HTTParty
  base_uri Constant::URI_HOMOLOG
  headers 'Content-Type' => 'application/json'

  def self.post_transfer(token, idCarrinho, transfer)
    transfer[:idCarrinho] = idCarrinho
    payload = { "obj": transfer }
    post('/Pagamento/PagarCarrinho', body: payload.to_json, headers: { 'Authorization' => token })
  end
end
