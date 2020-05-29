# frozen_string_literal: true

require 'time'
require 'utils/constant'
require 'services/user'

class ApiCreditoLottocap
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.post_payment_credit_lottocap(token, idCarrinho, credit)
    credit[:idCarrinho] = idCarrinho
    payload = { "obj": credit }
    post('/Pagamento/PagarCarrinho', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.post_buy_credit(token, credit)
    payload = { "obj": credit }
    post('/Pagamento/PagarCarrinho', body: payload.to_json, headers: { 'Authorization' => token })
  end
end
