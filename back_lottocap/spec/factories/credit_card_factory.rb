# frozen_string_literal: true

require_relative '../models/credit_card_model'

FactoryBot.define do
  factory :credit_card, class: CreditCardModel do
    idFormaPagamento { 5 }
    idCarrinho { 0 }
    nomeCompletoTitular { 'Otto Oliveira' }
    ccredNumero { '5521884306233764' }
    ccredValidadeMes { '11' }
    ccredValidadeAno { Constant::ValidadeAnoCartao }
    ccredCVV { '123' }
  end
end
