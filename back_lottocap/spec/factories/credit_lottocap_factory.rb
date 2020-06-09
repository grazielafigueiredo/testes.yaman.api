# frozen_string_literal: true

require_relative '../models/credit_lottocap_model'

FactoryBot.define do
  factory :buy_credit, class: CreditBuyModel do
    idFormaPagamento { 5 }
    idCarrinho { 0 }
    nomeCompletoTitular { 'Otto Oliveira' }
    ccredNumero { '5521884306233764' }
    ccredValidadeMes { '11' }
    ccredValidadeAno { Constant::VALIDADE_ANO_CARTAO }
    ccredCVV { '123' }
    flCompraDeCredito { true }
    valorCreditos { 20 }
  end
  factory :payment_credit, class: CreditPaymentModel do
    idFormaPagamento { 11 }
    idCarrinho { 0 }
    flCompraComCredito { true }
    flCompraDeCredito { false }
    valorCreditos { 0 }
    dadosComplementaresUsuario { nil }
    # utmCampanhas { '{\"conversao_medium\":\"direto\"}' } 
    sessionIdAmplitude { 1584628273657 }
    deviceIdAmplitude { 'b5b37a42-c1a0-4687-bd02-8a44257a4f20R' }
  end
end
