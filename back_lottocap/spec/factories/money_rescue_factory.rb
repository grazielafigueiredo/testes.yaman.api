# frozen_string_literal: true

require_relative '../models/money_rescue_model'

FactoryBot.define do
  factory :rescue, class: RescueModel do
    valor { 10.000 }
    idBanco { 1 }
    idTipoConta { '1' }
    agenciaNumero { '1234' }
    agenciaDigito { '1' }
    contaNumero { '0987654328' }
    contaDigito { '1' }
    cpf { '66530420061' }
    nomeTitular { 'Otto Oliveira Junior' }
  end
end
