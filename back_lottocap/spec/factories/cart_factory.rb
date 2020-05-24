# frozen_string_literal: true

require_relative '../models/cart_model'

FactoryBot.define do
  factory :cart, class: CartModel do
    idCarrinho { 0 }
    idProduto { Constant::IdProduto }
    idSerie { Constant::IdSerieMaxRegular }
    qtdItens { 0 }
  end
end
