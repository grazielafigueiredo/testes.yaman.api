require 'tiny_tds'    


# https://docs.microsoft.com/pt-br/sql/connect/ruby/step-3-proof-of-concept-connecting-to-sql-using-ruby?view=sql-server-ver15
class Database
    def initialize
        conn = {
            # username: 'graziela', 
            # password: '4KoNxOHqNtTd6zZ',  
            username: 'Lottocap', 
            password: 'L0ttocap@sql2018',  
            host: 'hmllottocap.database.windows.net', 
            port: 1433,  
            database: 'hmllottocap', 
            azure:true
        }
        @connection =  TinyTds::Client.new(conn)
        
    end

    # def initialize
    #     conn = {
    #         username: 'prdlottocap_Copy', 
    #         password: 'Lottocap',  
    #         host: 'hmllottocap.database.windows.net', 
    #         port: 1433,  
    #         database: 'L0ttocap@sql2018', 
    #         azure:true
    #     }
    #     @connection =  TinyTds::Client.new(conn)      
    # end

    def update_DataFinalVendaVigente(dataFinalVenda)
        @connection.execute("UPDATE Serie SET DataFinalVenda = #{dataFinalVenda} where IdSerie= #{Constant::IdSerie};")
    end

    def update_TodosProdutosIndisponiveisVitrine()
        @connection.execute("UPDATE Serie SET DataFinalVenda = '2018-12-25 17:09:00.000';")

    end

    def update_BloquearPagamento()
        time = Time.now.strftime('%F')
        @connection.execute("UPDATE Serie SET DataFinalVenda = '#{time}' where idSerie = #{Constant::IdSerie};")

    end

    def update_reservarSerie(reservado)
        @connection.execute("UPDATE TituloMatriz SET reservado = #{reservado} where idSerie = #{Constant::IdSerie};")

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

    def update_CreditoLottocap(saldoCredito)
        @connection.execute("UPDATE Usuario SET  SaldoCredito = #{saldoCredito}  where IdUsuario = #{Constant::UserID};")
    end

    def update_PremioResgate(valorBonus)
        @connection.execute("exec usp_setBonusUsuario @idUsuario = #{Constant::UserID}, @valorBonus = #{valorBonus};")
    end

    def update_deletePremioResgate()
        @connection.execute("UPDATE Usuario SET  SaldoPremio = 0.000  where IdUsuario = #{Constant::UserID};")
    end

    def select_GetQtdTitulosUsuario()
        @connection.execute("SELECT COUNT(tm.idTituloMatriz)
        FROM dbo.TituloMatriz tm
             INNER JOIN dbo.Titulo t ON t.IdTituloMatriz = tm.IdTituloMatriz
             INNER JOIN dbo.SERIE s ON tm.idSerie = s.IdSerie
        WHERE tm.idUsuarioCliente = #{Constant::UserID}
              AND t.DataVisualizacao IS NULL
              AND S.Aprovado = 1
              AND S.Ativo = 1
              AND S.idSerieEstado = 4;")
    end
end

# DELETE from TokenUsuario where IdUsuario = 3661