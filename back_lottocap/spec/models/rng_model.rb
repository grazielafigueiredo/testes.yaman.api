# frozen_string_literal: true

class RNGModel
  attr_accessor :produto, :concurso, :objetivo, :numeroMaximo, :qtdDezenasSorteadas

  def to_hash
    {
      produto: @produto,
      concurso: @concurso,
      objetivo: @objetivo,
      numeroMaximo: @numeroMaximo,
      qtdDezenasSorteadas: @qtdDezenasSorteadas
    }
  end
end
