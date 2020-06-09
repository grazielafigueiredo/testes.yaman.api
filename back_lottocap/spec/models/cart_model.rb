# frozen_string_literal: true

class CartModel
  attr_accessor :token, :idCarrinho, :idProduto, :idSerie, :qtdItens

  def to_hash
    {
      idCarrinho: @idCarrinho,
      idProduto: @idProduto,
      idSerie: @idSerie,
      qtdItens: @qtdItens
    }
  end
end
