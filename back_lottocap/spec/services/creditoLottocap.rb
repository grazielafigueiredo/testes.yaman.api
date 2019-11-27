# frozen_string_literal: true

require 'time'
require 'utils/constant'
require 'services/user'

class ApiCreditoLottocap
  include HTTParty
  base_uri 'https://hmlapi.lottocap.com.br/api/Pagamento'
  headers 'Content-Type' => 'application/json', 'Authorization' => Constant::Authorization

  def self.post_SucessoCreditoLottocap
    @SucessoCreditoLottocap = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoCreditoLottocap,
        "idCarrinho": Constant::IdCarrinho,
		"flCompraComCredito": true,

      }
    }
    post('/PagarCarrinho', body: @SucessoCreditoLottocap.to_json)
    end
end



