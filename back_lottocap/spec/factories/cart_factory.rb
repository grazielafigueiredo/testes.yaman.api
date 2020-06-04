# frozen_string_literal: true

require_relative '../models/cart_model'

FactoryBot.define do
  factory :cart, class: CartModel do
    idCarrinho { 0 }
    idProduto { Constant::IdProduto }
    idSerie { Constant::IdSerieMaxRegular }
    qtdItens { 1 }
  end
  factory :cart_afiliados, class: CartModel do
    idCarrinho { 0 }
    idProduto { 9 }
    idSerie { Constant::IdSerieJa17 }
    qtdItens { 1 }
  end
  factory :cart_remove, class: CartModel do
    idCarrinho { 0 }
    idProduto { Constant::IdProdutoJa }
    idSerie { Constant::IdSerieJa17 }
    qtdItens { 1 }
  end
end
