# frozen_string_literal: true

require_relative 'db_base'

require 'tiny_tds'
require 'timeout'

class TituloDB < DbBase
  def select_GetQtdTitulosUsuario(id_user)
    puts id_user
    query = "SELECT COUNT(tm.idTituloMatriz) AS TOTAL
        FROM dbo.TituloMatriz tm
             INNER JOIN dbo.Titulo t ON t.IdTituloMatriz = tm.IdTituloMatriz
             INNER JOIN dbo.SERIE s ON tm.idSerie = s.IdSerie
        WHERE tm.idUsuarioCliente = #{id_user}
              AND t.DataVisualizacao IS NULL
              AND S.Aprovado = 1
              AND S.Ativo = 1
              AND S.idSerieEstado = 4;"
    @connection.execute(query).first
  end
end
