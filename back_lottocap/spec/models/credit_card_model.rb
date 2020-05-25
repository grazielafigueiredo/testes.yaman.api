# frozen_string_literal: true

class CreditCardModel
  attr_accessor :idFormaPagamento, :idCarrinho, :nomeCompletoTitular, :ccredNumero,
                :ccredValidadeMes, :ccredValidadeAno, :ccredCVV

  def to_hash
    {
      idFormaPagamento: @idFormaPagamento,
      idCarrinho: @idCarrinho,
      nomeCompletoTitular: @nomeCompletoTitular,
      ccredNumero: @ccredNumero,
      ccredValidadeMes: @ccredValidadeMes,
      ccredValidadeAno: @ccredValidadeAno,
      ccredCVV: @ccredCVV
    }
  end
end
