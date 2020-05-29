# frozen_string_literal: true

require_relative 'db_base'

require 'tiny_tds'
require 'timeout'

class TituloDB < DbBase
  def select_get_amount_titulo(id_user)
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

  def delete_titulo_buy(id_user)
    query = "DECLARE @id_user AS INTEGER=#{id_user}

      DELETE
      FROM Titulo
      WHERE IdCarrinhoItem
      IN (
        SELECT IdCarrinhoItem
        FROM CarrinhoItem
        WHERE IdCarrinho
        IN (
          SELECT IdCarrinho
          FROM Carrinho
          WHERE IdUsuarioCriacao = @id_user
        )
      )"
    @connection.execute(query)
  end
end
