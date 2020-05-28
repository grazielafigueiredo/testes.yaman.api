# frozen_string_literal: true

class RescueModel
  attr_accessor :valor, :idBanco, :idTipoConta, :agenciaNumero, :agenciaDigito,
                :contaNumero, :contaDigito, :cpf, :nomeTitular

  def to_hash
    {
      valor: @valor,
      idBanco: @idBanco,
      idTipoConta: @idTipoConta,
      agenciaNumero: @agenciaNumero,
      agenciaDigito: @agenciaDigito,
      contaNumero: @contaNumero,
      contaDigito: @contaDigito,
      cpf: @cpf,
      nomeTitular: @nomeTitular
    }
  end
end
