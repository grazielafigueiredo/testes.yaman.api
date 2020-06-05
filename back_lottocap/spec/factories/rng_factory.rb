# frozen_string_literal: true

require_relative '../models/rng_model'

FactoryBot.define do
  factory :rng, class: RNGModel do
    produto { 'Signos' }
    concurso { '5' }
    objetivo { 'Sorteio' }
    numeroMaximo { 12 }
    qtdDezenasSorteadas { 3 }
  end
end