require 'tiny_tds'    


# https://docs.microsoft.com/pt-br/sql/connect/ruby/step-3-proof-of-concept-connecting-to-sql-using-ruby?view=sql-server-ver15
class Database
    def initialize
        conn = {
            username: 'graziela', 
            password: '4KoNxOHqNtTd6zZ',  
            host: 'hmllottocap.database.windows.net', 
            port: 1433,  
            database: 'hmllottocap', 
            azure:true
        }
        @connection =  TinyTds::Client.new(conn)
        
    end

    def update_DataFinalVenda()
        @connection.execute("UPDATE Serie SET DataFinalVenda = '2018-12-25 17:09:00.000' where IdSerie= #{Constant::IdSerie};")
    end

    def update_DataFinalVendaVigente()
        @connection.execute("UPDATE Serie SET DataFinalVenda = '2020-12-25 17:09:00.000' where IdSerie= #{Constant::IdSerie};")
    end

    def update_TodosProdutosIndisponiveisVitrine()
        @connection.execute("UPDATE Serie SET DataFinalVenda = '2018-12-25 17:09:00.000';")

    end

    def update_AtualizarSerieAndamento()
        @connection.execute("UPDATE Serie SET DataFinalVenda = '2018-12-25 17:09:00.000' where idSerie = #{Constant::IdSerie};")

    end

    def update_BloquearPagamento()
        @connection.execute("UPDATE Serie SET DataFinalVenda = @time where idSerie = ;")

    end

    def update_reservarSerie86()
        @connection.execute("UPDATE TituloMatriz SET reservado = 1 where idSerie = #{Constant::IdSerie};")

    end

    def update_disponibilizarSerie86()
        @connection.execute("UPDATE TituloMatriz SET reservado = 0 where idSerie = #{Constant::IdSerie};")

    end

    def update_MaxIndisponiveisVitrine()
        @connection.execute("UPDATE Serie SET DataFinalVenda = '2018-12-25 17:09:00.000' where idSerie in (86,87);")

    end

    def update_VendaFinalDisponiveisVitrine()
        @connection.execute("UPDATE Serie SET DataFinalVenda = '2020-12-25 17:09:00.000';")
    end

    def update_MaxReservadosDisponiveis()
      res =  @connection.execute("UPDATE TituloMatriz SET reservado = 0 where idSerie in (86, 87);")
    ##### reservar todos os titulos da série MAX
    puts 'Affected rows' 
    puts res.do
    end

    def update_MaxReservadosIndisponiveis()
      res =  @connection.execute("UPDATE TituloMatriz SET reservado = 1 where idSerie in (86, 87);")
    ##### disponibilizar todos os titulos
    puts 'Affected rows' 
    puts res.do
    end
end

