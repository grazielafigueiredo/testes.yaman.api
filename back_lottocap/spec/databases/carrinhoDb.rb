require_relative "db_base"

class CarrinhoDb < DbBase
    # def update_maxReservados(reservado) ##### reservar todos os titulos da série MAX
    #     # res = @connection.execute("UPDATE TituloMatriz
    #     #                                 SET reservado = #{reservado}
    #     #                                 FROM TituloMatriz as T
    #     #                                 INNER JOIN Serie as S ON T.idSerie = S.IdSerie
    #     #                                 INNER JOIN TemplateSerie as TS ON TS.Id = S.TemplateSerieId
    #     #                                 INNER JOIN Plano as P ON TS.PlanoId = P.Id
    #     #                                 WHERE P.ProdutoId = 1"
    #     #                             )
    #     res = @connection.execute(
    #         "UPDATE TituloMatriz
    #         SET reservado = #{reservado}
    #         WHERE idSerie = #{Constant::IdSerieMaxRegular}"
    #     )
    #     sleep 5
    #     puts 'Affected rows'
    #     puts res.do
    # end
    def update_maxReservados(reservado) ##### reservar todos os titulos da série MAX
        # res = @connection.execute("UPDATE TituloMatriz
        #                                 SET reservado = #{reservado}
        #                                 FROM TituloMatriz as T
        #                                 INNER JOIN Serie as S ON T.idSerie = S.IdSerie
        #                                 INNER JOIN TemplateSerie as TS ON TS.Id = S.TemplateSerieId
        #                                 INNER JOIN Plano as P ON TS.PlanoId = P.Id
        #                                 WHERE P.ProdutoId = 1"
        #                             )
        res = @connection.execute(
            "UPDATE TituloMatriz
            SET reservado = #{reservado}
            WHERE idSerie = #{Constant::IdSerieMaxRegular}"
        )
        sleep 5
        puts 'Affected rows'
        puts res.do
    end

    def get_titulos_reservados()
        query = "SELECT * FROM TituloMatriz WHERE reservado = 0 AND idSerie = #{Constant::IdSerieMaxRegular}"
      
        result = @connection.execute(query)
    
        titulos = []
        result.each do |row|
        #   titulos.push(row)
        res = @connection.execute(
            "UPDATE TituloMatriz
            SET reservado = #{reservado}
            WHERE idSerie = #{Constant::IdSerieMaxRegular}"
        )
        end
    
        return titulos
    end


    def update_dataFinalVendaVigente(dataFinalVenda)
        t = @connection.execute(
            "UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}' 
            WHERE IdSerie= #{Constant::IdSerieMaxRegular};"
        )
        puts t.do
    end

    def update_maxNaVitrine(dataFinalVenda)
        @connection.execute(
            "UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}'
            INNER JOIN TemplateSerie as TS ON TS.Id = S.TemplateSerieId
            INNER JOIN Plano as P ON TS.PlanoId = P.Id
            WHERE P.ProdutoId = 1"
        )
    end
end