# frozen_string_literal: true

require_relative '../models/cart_model'

FactoryBot.define do
  factory :cart, class: CartModel do
    idCarrinho { 0 }
    idProduto { Constant::IdProduto }
    idSerie { Constant::ID_SERIE_MAX_REGULAR }
    qtdItens { 1 }
  end
  factory :cart_afiliados, class: CartModel do
    idCarrinho { 0 }
    idProduto { 9 }
    idSerie { Constant::ID_SERIE_JA_17 }
    qtdItens { 1 }
  end
  factory :cart_remove, class: CartModel do
    idCarrinho { 0 }
    idProduto { Constant::IdProdutoJa }
    idSerie { Constant::ID_SERIE_JA_17 }
    qtdItens { 1 }
  end
end
