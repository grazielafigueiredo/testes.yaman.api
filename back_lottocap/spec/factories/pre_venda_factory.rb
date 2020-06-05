# frozen_string_literal: true

require_relative '../models/pre_venda_model'

FactoryBot.define do
  factory :search_dezenas, class: SearchPreModel do
    dezenas { %w[01 02] }
    idSerie { Constant::ID_SERIE_MAX_PRE_VENDA }
  end
  factory :cart_dezenas, class: CartPreModel do
    idSerie { Constant::ID_SERIE_MAX_PRE_VENDA }
    lstDezenas { ['01 02 03'] }
    flPromoAtiva { false }
  end
end
