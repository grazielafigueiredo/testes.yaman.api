# frozen_string_literal: true

class TituloModel
  attr_accessor :idTitulo

  def to_hash
    {
      idTitulo: @idTitulo
    }
  end
end