# frozen_string_literal: true

require_relative '../models/credit_card_model'

FactoryBot.define do
  factory :credit_card, class: CreditCardModel do
    idFormaPagamento { 5 }
    idCarrinho { 0 }
    nomeCompletoTitular { 'Otto Oliveira Junior' }
    ccredNumero { '5521884306233764' }
    ccredValidadeMes { '11' }
    ccredValidadeAno { Constant::VALIDADE_ANO_CARTAO }
    ccredCVV { '123' }
  end
end
