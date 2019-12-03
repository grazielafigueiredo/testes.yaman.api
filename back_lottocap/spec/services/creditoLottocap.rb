# frozen_string_literal: true

require 'time'
require 'utils/constant'
require 'services/user'

class ApiCreditoLottocap
  include HTTParty
  base_uri 'https://hmlapi.lottocap.com.br/api'
  headers 'Content-Type' => 'application/json'

  def self.post_CreditoLottocap(token, idCarrinho)
    headers[:Authorization] = token

    @CreditoLottocap = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoCreditoLottocap,
        "idCarrinho": idCarrinho,
        "flCompraComCredito": true,

      }
    }
    post('/Pagamento/PagarCarrinho', body: @CreditoLottocap.to_json)
  end

  def self.post_comprarCreditoLottocap(token, idCarrinho)
    headers[:Authorization] = token

    @comprarCreditoLottocap = {
      "obj": {
        "idFormaPagamento": 5,
        "idCarrinho": idCarrinho,
        "nomeCompletoTitular": "FGHJ FGHJKL",
        "ccredNumero": Faker::CNPJ.numeric,
        "ccredValidadeMes": "12",
        "ccredValidadeAno": "34",
        "ccredCVV": "123",
        "flCompraDeCredito": true,
        "valorCreditos": 250,
      }
    }
    post('/Pagamento/PagarCarrinho', body: @comprarCreditoLottocap.to_json)
  end
end







