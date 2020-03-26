require_relative "db_base"

class CarrinhoDb < DbBase
    def update_maxReservados(reservado) ##### reservar todos os titulos da série MAX
        res = @connection.execute("UPDATE TituloMatriz
                                        SET reservado = #{reservado}
                                        FROM TituloMatriz as T
                                        INNER JOIN Serie as S ON T.idSerie = S.IdSerie
                                        WHERE IdProduto = 1")
        sleep 5
        puts 'Affected rows'
        puts res.do
    end

    def update_dataFinalVendaVigente(dataFinalVenda)
        t = @connection.execute("UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}' where IdSerie= #{Constant::IdSerieMaxRegular};")
        puts t.do
    end

    def update_maxNaVitrine(dataFinalVenda)
        @connection.execute("UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}' where IdProduto = 1;")
        # sleep 2
    end
end