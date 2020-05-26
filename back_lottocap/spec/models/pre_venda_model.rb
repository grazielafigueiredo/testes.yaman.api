# frozen_string_literal: true

class CartPreModel
  attr_accessor :idSerie, :lstDezenas, :flPromoAtiva

  def to_hash
    {
      idSerie: @idSerie,
      lstDezenas: @lstDezenas,
      flPromoAtiva: @flPromoAtiva
    }
  end
end
class SearchPreModel
  attr_accessor :dezenas, :idSerie

  def to_hash
    {
      dezenas: @dezenas,
      idSerie: @idSerie
    }
  end
end
