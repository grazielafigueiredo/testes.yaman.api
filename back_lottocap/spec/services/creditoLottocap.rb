# frozen_string_literal: true

require 'time'
require 'utils/constant'
require 'services/user'

class ApiCreditoLottocap
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.post_pagarCarrinhoComCreditoLottocap(token, idCarrinho)
    headers[:Authorization] = token

    @creditoLottocap = {
        "obj": {
          "idFormaPagamento": 11,
          "idCarrinho": idCarrinho,
          "flCompraComCredito": true,
          "flCompraDeCredito": false,
          "valorCreditos": 0,
          "dadosComplementaresUsuario": nil,
          "utmCampanhas": "{\"conversao_medium\":\"direto\"}",
          "sessionIdAmplitude": 1584628273657,
          "deviceIdAmplitude": "b5b37a42-c1a0-4687-bd02-8a44257a4f20R"
        },
        "atualPagina": 1,
        "tamanhoPagina": 9999
    }
    post('/Pagamento/PagarCarrinho', body: @creditoLottocap.to_json)
  end

  def self.post_comprarCreditoLottocap(token, idCarrinho)
    headers[:Authorization] = token

    @comprarCreditoLottocap = {
      "obj": {
        "idFormaPagamento": 5,
        "idCarrinho": idCarrinho,
        "nomeCompletoTitular": "FGHJ FGHJKL",
        "ccredNumero": '5521884306233764',
        "ccredValidadeMes": "12",
        "ccredValidadeAno": "34",
        "ccredCVV": "123",
        "flCompraDeCredito": true,
        "valorCreditos": 20,
      }
    }
    post('/Pagamento/PagarCarrinho', body: @comprarCreditoLottocap.to_json)
  end
end







