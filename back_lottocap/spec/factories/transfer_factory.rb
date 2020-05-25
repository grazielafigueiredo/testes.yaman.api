# frozen_string_literal: true

require_relative '../models/transfer_model'

FactoryBot.define do
  factory :transfer_bradesco, class: TransferBradescoModel do
    idFormaPagamento { 6 }
    idCarrinho { 0 }
    transfAgencia { Faker::Bank.account_number(digits: 4) }
    transfConta { Faker::Bank.account_number(digits: 4) }
    transfContaDigito { Faker::Bank.account_number(digits: 1) }
    nomeCompletoTitular { 'Otto Oliveira Junior' }
  end
  factory :transfer_itau, class: TransferItauModel do
    idFormaPagamento { 7 }
    idCarrinho { 0 }
    transfAgencia { Faker::Bank.account_number(digits: 4) }
    transfAgenciaDigito { Faker::Bank.account_number(digits: 1) }
    transfConta { Faker::Bank.account_number(digits: 4) }
    transfContaDigito { Faker::Bank.account_number(digits: 1) }
    nomeCompletoTitular { 'Otto Oliveira Junior' }
  end
  factory :transfer_santander, class: TransferSantanderModel do
    idFormaPagamento { 8 }
    idCarrinho { 0 }
    cpf { '66530420061' }
  end
  factory :transfer_bbrasil, class: TransferBBrasilModel do
    idFormaPagamento { 9 }
    idCarrinho { 0 }
    transfAgencia { Faker::Bank.account_number(digits: 4) }
    transfAgenciaDigito { Faker::Bank.account_number(digits: 1) }
    transfConta { Faker::Bank.account_number(digits: 4) }
    transfContaDigito { Faker::Bank.account_number(digits: 1) }
    nomeCompletoTitular { 'Otto Oliveira Junior' }
  end
end
