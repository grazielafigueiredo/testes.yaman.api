# frozen_string_literal: true

class CreditCardModel
  attr_accessor :idFormaPagamento, :idCarrinho, :nomeCompletoTitular, :ccredNumero,
                :ccredValidadeMes, :ccredValidadeAno, :ccredCVV, :flCompraDeCredito,
                :valorCreditos, :dadosComplementaresUsuario
                
  def to_hash
    {
      idFormaPagamento: @idFormaPagamento,
      idCarrinho: @idCarrinho,
      nomeCompletoTitular: @nomeCompletoTitular,
      ccredNumero: @ccredNumero,
      ccredValidadeMes: @ccredValidadeMes,
      ccredValidadeAno: @ccredValidadeAno,
      ccredCVV: @ccredCVV
      # ,
      # flCompraDeCredito: @flCompraDeCredito,
      # valorCreditos: @valorCreditos,
      # dadosComplementaresUsuario: @dadosComplementaresUsuario

    }
  end
end
