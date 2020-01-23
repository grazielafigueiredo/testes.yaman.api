require 'tiny_tds'    


class Database
    def initialize
        conn = {
            # username: 'graziela', 
            # password: '4KoNxOHqNtTd6zZ',  
            username: 'Lottocap', 
            password: 'L0ttocap@sql2018',  
            host: 'hmllottocap.database.windows.net', 
            port: 1433,  
            database: 'hmllottocaptests', 
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
        t = @connection.execute("UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}' where IdSerie= #{Constant::IdSerie};")
        puts t.do
    end

    def update_TodosProdutosIndisponiveisVitrine(dataFinalVenda)
        @connection.execute("UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}';")

    end

    def update_BloquearPagamento()
        time = Time.now.strftime('%F')
        @connection.execute("UPDATE Serie SET DataFinalVenda = '#{time}' where idSerie = #{Constant::IdSerie};")

    end

    def update_reservarSerie(reservado)
       t = @connection.execute("UPDATE TituloMatriz SET reservado = #{reservado} where idSerie = #{Constant::IdSerie};")
       sleep 5
        puts t.do
    end

    def update_MaxNaVitrine(dataFinalVenda)
        @connection.execute("UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}' where IdProduto = 1;")
        # sleep 2
    end

    def update_MaxReservados(reservado)     ##### reservar todos os titulos da série MAX
        res =  @connection.execute("UPDATE TituloMatriz 
                                    SET reservado = #{reservado}
                                    FROM TituloMatriz as T
                                    INNER JOIN Serie as S ON T.idSerie = S.IdSerie
                                    WHERE IdProduto = 1")
        sleep 45
        puts 'Affected rows' 
        puts res.do
    end

    def update_CreditoLottocap(saldoCredito)
        @connection.execute("BEGIN 
            DECLARE @saldoTotal decimal(18, 3);
            DECLARE @saldoPremio decimal(18, 3);
            DECLARE @saldoCredito decimal(18, 3);
            DECLARE @saldoCapitalizacao decimal(18, 3);
    
            SELECT
                @saldoTotal = saldoTotal,
                @saldoPremio = saldoPremio,
                @saldoCredito = saldoCredito,
                @saldoCapitalizacao = saldoCapitalizacao
            FROM USUARIO
            WHERE
                idUsuario = #{Constant::UserID};
    
            INSERT INTO [dbo].[UsuarioCredito] (
                [idUsuario],
                [dtCredito],
                [valor],
                [flPremio],
                [flCredito],
                [flDebito],
                [flResgate],
                [flEstorno],
                [idStatus],
                [idTituloMatrizApuracaoConcurso],
                [idPagamento],
                [idTituloMatriz],
                [idConcurso],
                [idResgate],
                [idPromocao],
                [idPromocaoUsuario],
                [idPromocaoUsuarioItem],
                [saldo],
                [saldoPremio],
                [saldoCredito],
                [saldoCapitalizacao],
                [utilizadoPremio],
                [utilizadoCredito],
                [utilizadoCapitalizacao],
                [dsTipoCredito],
                [dsTipoCreditoWeb],
                [nmConcurso],
                [dtConcurso],
                [nmTipoPremio],
                [nmProdutoSerie]
            )
            VALUES
            (
                #{Constant::UserID},
                --idUsuario
                [dbo].fn_GETDATE(),
                #{saldoCredito},
                --vlTransação
                0,
                1,
                --flCrédito
                0,
                0,
                0,
                1,
                --Status
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                0,
                0,
                0,
                @saldoTotal + #{saldoCredito},
                --saldo
                @saldoPremio,
                --saldoPremio
                @saldoCredito + #{saldoCredito},
                --saldoCrédito
                @saldoCapitalizacao,
                --saldoCapitalização
                0,
                0,
                0,
                'Bônus',
                'Bônus',
                NULL,
                NULL,
                NULL,
                NULL
            );
    
            UPDATE Usuario
            SET
                SaldoCredito = #{saldoCredito},
                SaldoTotal = #{saldoCredito}
            WHERE
                IdUsuario = #{Constant::UserID};
        END;")
    # end        puts rs
    end

    def update_PremioResgate(valorBonus)

        @connection.execute("BEGIN 
            DECLARE @saldoTotal decimal(18, 3);
            DECLARE @saldoPremio decimal(18, 3);
            DECLARE @saldoCredito decimal(18, 3);
            DECLARE @saldoCapitalizacao decimal(18, 3);
    
            SELECT
                @saldoTotal = saldoTotal,
                @saldoPremio = saldoPremio,
                @saldoCredito = saldoCredito,
                @saldoCapitalizacao = saldoCapitalizacao
            FROM USUARIO
            WHERE
                idUsuario = #{Constant::UserID};
    
            INSERT INTO [dbo].[UsuarioCredito] (
                [idUsuario],
                [dtCredito],
                [valor],
                [flPremio],
                [flCredito],
                [flDebito],
                [flResgate],
                [flEstorno],
                [idStatus],
                [idTituloMatrizApuracaoConcurso],
                [idPagamento],
                [idTituloMatriz],
                [idConcurso],
                [idResgate],
                [idPromocao],
                [idPromocaoUsuario],
                [idPromocaoUsuarioItem],
                [saldo],
                [saldoPremio],
                [saldoCredito],
                [saldoCapitalizacao],
                [utilizadoPremio],
                [utilizadoCredito],
                [utilizadoCapitalizacao],
                [dsTipoCredito],
                [dsTipoCreditoWeb],
                [nmConcurso],
                [dtConcurso],
                [nmTipoPremio],
                [nmProdutoSerie]
            )
            VALUES
            (
                #{Constant::UserID},
                --idUsuario
                [dbo].fn_GETDATE(),
                #{valorBonus},
                --vlTransação
                0,
                1,
                --flCrédito
                0,
                0,
                0,
                1,
                --Status
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                0,
                0,
                0,
                @saldoTotal + #{valorBonus},
                --saldo
                @saldoPremio,
                --saldoPremio + #{valorBonus},
                @saldoCredito + #{valorBonus},
                --saldoCrédito
                @saldoCapitalizacao,
                --saldoCapitalização
                0,
                0,
                0,
                'Bônus',
                'Bônus',
                NULL,
                NULL,
                NULL,
                NULL
            );
    
            UPDATE Usuario
            SET
                SaldoCredito = #{valorBonus},
                SaldoPremio = #{valorBonus},
                SaldoTotal = #{valorBonus}
            WHERE
                IdUsuario = #{Constant::UserID};
        END;")
    end

    def update_deletePremioResgate()
        @connection.execute("UPDATE Usuario SET  SaldoPremio = 0.000  where IdUsuario = #{Constant::UserID};")
    end

    def select_GetQtdTitulosUsuario()
        t = @connection.execute("SELECT COUNT(tm.idTituloMatriz) AS TOTAL
        FROM dbo.TituloMatriz tm
             INNER JOIN dbo.Titulo t ON t.IdTituloMatriz = tm.IdTituloMatriz
             INNER JOIN dbo.SERIE s ON tm.idSerie = s.IdSerie
        WHERE tm.idUsuarioCliente = #{Constant::UserID}
              AND t.DataVisualizacao IS NULL
              AND S.Aprovado = 1
              AND S.Ativo = 1
              AND S.idSerieEstado = 4;")

        return t
    end

    def update_preVenda()
        today = Date.today
        today_add_3_days = today + 1
        today_add_6_days = today + 6
        today_add_9_days = today + 9

        ta = @connection.execute("UPDATE Serie SET DataInicialPreVenda= '#{today}',  
                                                  DataFinalPreVenda= '#{today_add_3_days}', 
                                                  DataInicialVenda= '#{today_add_6_days}',
                                                  DataFinalVenda= '#{today_add_9_days}' 
                                WHERE IdSerie= #{Constant::IdSerieMaxPreVenda};")
        puts ta.do

        puts today
        puts today_add_3_days
        puts today_add_6_days
        puts today_add_9_days
    end
end

