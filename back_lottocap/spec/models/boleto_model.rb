# frozen_string_literal: true

class BoletoModel
  attr_accessor :idFormaPagamento, :idCarrinho, :boletoSenderHash

  def to_hash
    {
      idFormaPagamento: @idFormaPagamento,
      idCarrinho: @idCarrinho,
      boletoSenderHash: @boletoSenderHash
    }
  end
end