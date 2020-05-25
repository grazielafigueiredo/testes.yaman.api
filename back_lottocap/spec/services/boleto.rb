# frozen_string_literal: true

require 'time'
require 'utils/constant'
require 'services/user'

class ApiBoleto
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.post_payment_cart_boleto(token, payload, idCarrinho)
    headers[:Authorization] = token

    puts payload
    puts idCarrinho
    payload[:idCarrinho] = idCarrinho
    r = { "obj": payload }
    post('/Pagamento/PagarCarrinho', body: r.to_json)
  end
end
