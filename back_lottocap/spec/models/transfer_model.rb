# frozen_string_literal: true

class TransferBradescoModel
  attr_accessor :idFormaPagamento, :idCarrinho, :transfAgencia, :transfConta,
                :transfContaDigito, :nomeCompletoTitular

  def to_hash
    {
      idFormaPagamento: @idFormaPagamento,
      idCarrinho: @idCarrinho,
      transfAgencia: @transfAgencia,
      transfConta: @transfConta,
      transfContaDigito: @transfContaDigito,
      nomeCompletoTitular: @nomeCompletoTitular
    }
  end
end

class TransferItauModel
  attr_accessor :idFormaPagamento, :idCarrinho, :transfAgencia, :transfAgenciaDigito,
                :transfConta, :transfContaDigito, :nomeCompletoTitular

  def to_hash
    {
      idFormaPagamento: @idFormaPagamento,
      idCarrinho: @idCarrinho,
      transfAgencia: @transfAgencia,
      transfAgenciaDigito: @transfAgenciaDigito,
      transfConta: @transfConta,
      transfContaDigito: @transfContaDigito,
      nomeCompletoTitular: @nomeCompletoTitular
    }
  end
end

class TransferSantanderModel
  attr_accessor :idFormaPagamento, :idCarrinho, :cpf

  def to_hash
    {
      idFormaPagamento: @idFormaPagamento,
      idCarrinho: @idCarrinho,
      cpf: @cpf
    }
  end
end

class TransferBBrasilModel
  attr_accessor :idFormaPagamento, :idCarrinho, :transfAgencia,
                :transfAgenciaDigito, :transfConta, :transfContaDigito, :nomeCompletoTitular

  def to_hash
    {
      idFormaPagamento: @idFormaPagamento,
      idCarrinho: @idCarrinho,
      transfAgencia: @transfAgencia,
      transfAgenciaDigito: @transfAgenciaDigito,
      transfConta: @transfConta,
      transfContaDigito: @transfContaDigito,
      nomeCompletoTitular: @nomeCompletoTitular
    }
  end
end
