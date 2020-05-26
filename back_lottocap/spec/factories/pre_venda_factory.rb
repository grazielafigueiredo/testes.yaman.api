# frozen_string_literal: true

require_relative '../models/pre_venda_model'

FactoryBot.define do
  factory :search_dezenas, class: SearchPreModel do
    dezenas { %w[01 02] }
    idSerie { Constant::IdSerieMaxPreVenda }
  end
  factory :cart_dezenas, class: CartPreModel do
    idSerie { Constant::IdSerieMaxPreVenda }
    lstDezenas { ['01 02 03'] }
    flPromoAtiva { false }
  end
end
