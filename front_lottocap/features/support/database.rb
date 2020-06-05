# frozen_string_literal: true

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
      azure: true
    }
    @connection = TinyTds::Client.new(conn)
  end

  def update_creditoLottocap(saldoCredito)
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
                            WHERE IdSerie= #{Constant::ID_SERIE_MAX_PRE_VENDA};")
    puts ta.do

    puts today
    puts today_add_3_days
    puts today_add_6_days
    puts today_add_9_days
  end
end
