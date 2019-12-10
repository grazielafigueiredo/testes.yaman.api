# frozen_string_literal: true

require 'time'
require 'utils/constant'
require 'services/user'

class ApiBoleto
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.post_SucessoBoleto(token, idCarrinho)
    headers[:Authorization] = token

    @SucessoBoleto = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoBoleto,
        "idCarrinho": idCarrinho,
        "boletoSenderHash": '667a4c201f9cdaaa382f6c89180770243d6ca8f01ca6cdcf7a7aed56b684cadc'
      }
    }
    post('/Pagamento/PagarCarrinho', body: @SucessoBoleto.to_json)
  end
end
