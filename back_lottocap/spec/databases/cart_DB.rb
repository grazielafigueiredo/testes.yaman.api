require_relative "db_base"

class CartDB < DbBase
    def update_maxReservados(reservado, idSerie) ##### reservar todos os titulos da série MAX
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
            WHERE idSerie = #{idSerie}"
        )
        sleep 5
        puts 'Affected rows'
        puts res.do
    end

    def get_titulos_reservados(reservado,idSerie)
        result = @connection.execute(
            "SELECT idTituloMatriz FROM TituloMatriz 
            WHERE reservado = #{reservado}
            AND idSerie = #{idSerie}")

        titulos = []
        result.each do |titulo|
            titulos.push(titulo)
        end

        return titulos
    end

    def disponibiliza_titulos(ids_)
        
        list_ids = ''
        ids_.each do |titulo|
            list_ids += titulo['idTituloMatriz'].to_s
            list_ids += ','
        end

        list_ids.delete_suffix!(',')
        
        # res = @connection.execute(
        #     "UPDATE TituloMatriz
        #     SET reservado = 0
        #     WHERE idTituloMatriz in (#{list_ids})"
        # )
        # sleep 5
        # puts 'Affected rows'
        # puts res.do
    end


    def update_dataFinalVendaVigente(dataFinalVenda)
        t = @connection.execute(
            "UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}' 
            WHERE IdSerie= #{Constant::ID_SERIE_MAX_REGULAR};"
        )
        puts t.do
    end

    def update_maxNaVitrine(dataFinalVenda)
        # @connection.execute(
        #     "UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}'
        #     INNER JOIN TemplateSerie as TS ON TS.Id = S.TemplateSerieId
        #     INNER JOIN Plano as P ON TS.PlanoId = P.Id
        #     WHERE P.ProdutoId = 1"
        # )
        @connection.execute(
            "UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}'
            WHERE IdProduto = 1"
        )
    end

    def update_products_vitrine(dataFinalVenda, id_serie)
        @connection.execute("UPDATE Serie 
          SET DataFinalVenda = '#{dataFinalVenda}'
          WHERE IdSerie = #{id_serie};")
    end
end