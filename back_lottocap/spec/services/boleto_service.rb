# frozen_string_literal: true

require 'time'
require 'utils/constant'
require 'services/user'

class ApiBoleto
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.post_payment_cart_boleto(token, idCarrinho, payment_boleto)
    headers[:Authorization] = token
    payment_boleto[:idCarrinho] = idCarrinho
    payload = { "obj": payment_boleto }

    post('/Pagamento/PagarCarrinho', body: payload.to_json)
  end
end
