# frozen_string_literal: true

require_relative 'db_base'

class CreditoLotto < DbBase
  def update_creditoLottocap(saldoCredito, idUsuario)
    @connection.execute("DECLARE @idUsuario AS INTEGER=#{idUsuario}
            DECLARE @saldo AS INTEGER=#{saldoCredito}

            BEGIN
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
                idUsuario = @idUsuario;

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
                @idUsuario,
                --idUsuario
                [dbo].fn_GETDATE(),
                @saldo,
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
                @saldoTotal + @saldo,
                --saldo
                @saldoPremio,
                --saldoPremio
                @saldoCredito + @saldo,
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
                SaldoCredito = @saldo,
                SaldoTotal = @saldo
            WHERE
                IdUsuario = @idUsuario;
        END;")
  end
end
