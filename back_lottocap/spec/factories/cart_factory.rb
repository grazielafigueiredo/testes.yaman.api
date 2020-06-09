# frozen_string_literal: true

require_relative '../models/cart_model'

FactoryBot.define do
  factory :cart, class: CartModel do
    token { 0 }
    idCarrinho { 0 }
    idProduto { Constant::ID_PRODUTO_MAX }
    idSerie { Constant::ID_SERIE_MAX_REGULAR }
    qtdItens { 1 }

    # after(:build) do |cart|
      
    #   puts token
    #   carrinho = ApiCart.post_add_item_cart(token, cart.to_hash)
    #   idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']
    # end
  end
  factory :cart_afiliados, class: CartModel do
    idCarrinho { 0 }
    idProduto { 9 }
    idSerie { Constant::ID_SERIE_JA_17 }
    qtdItens { 1 }
  end
  factory :cart_remove, class: CartModel do
    idCarrinho { 0 }
    idProduto { Constant::ID_PRODUTO_MAX }
    idSerie { Constant::ID_SERIE_JA_17 }
    qtdItens { 1 }
  end
end
