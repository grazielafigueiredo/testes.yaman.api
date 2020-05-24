# frozen_string_literal: true

require_relative '../models/boleto_model'

FactoryBot.define do
  factory :boleto, class: BoletoModel do
    idFormaPagamento { 10 }
    idCarrinho { 0 }
    boletoSenderHash { '667a4c201f9cdaaa382f6c89180770243d6ca8f01ca6cdcf7a7aed56b684cadc' }
  end
end
