# frozen_string_literal: true

class CreditBuyModel
  attr_accessor :idFormaPagamento, :idCarrinho, :nomeCompletoTitular, :ccredNumero,
                :ccredValidadeMes, :ccredValidadeAno, :ccredCVV, :flCompraDeCredito, :valorCreditos

  def to_hash
    {
      idFormaPagamento: @idFormaPagamento,
      idCarrinho: @idCarrinho,
      nomeCompletoTitular: @nomeCompletoTitular,
      ccredNumero: @ccredNumero,
      ccredValidadeMes: @ccredValidadeMes,
      ccredValidadeAno: @ccredValidadeAno,
      ccredCVV: @ccredCVV,
      flCompraDeCredito: @flCompraDeCredito,
      valorCreditos: @valorCreditos
    }
  end
end

class CreditPaymentModel
  attr_accessor :idFormaPagamento, :idCarrinho, :flCompraComCredito, :flCompraDeCredito,
                :valorCreditos, :dadosComplementaresUsuario, :utmCampanhas, :sessionIdAmplitude, :deviceIdAmplitude

  def to_hash
    {
      idFormaPagamento: @idFormaPagamento,
      idCarrinho: @idCarrinho,
      flCompraComCredito: @flCompraComCredito,
      flCompraDeCredito: @flCompraDeCredito,
      valorCreditos: @valorCreditos,
      dadosComplementaresUsuario: @dadosComplementaresUsuario,
      utmCampanhas: @utmCampanhas,
      sessionIdAmplitude: @sessionIdAmplitude,
      deviceIdAmplitude: @deviceIdAmplitude
    }
  end
end
