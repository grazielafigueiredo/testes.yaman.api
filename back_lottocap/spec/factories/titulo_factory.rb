# frozen_string_literal: true

require_relative '../models/titulo_model'

FactoryBot.define do
  factory :titulo, class: TituloModel do
    idTitulo { 0 }
  end
end
