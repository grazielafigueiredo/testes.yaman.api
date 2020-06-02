# frozen_string_literal: true

require_relative 'db_base'

require 'tiny_tds'
require 'timeout'

class RescueDB < DbBase
  def update_premium_rescue(idUser, valueBonus)
    @connection.execute("
            DECLARE @id AS INTEGER=#{idUser}
            DECLARE @insertsaldo AS INTEGER=#{valueBonus}

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
                idUsuario = @id;

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
                @id,
                --idUsuario
                [dbo].fn_GETDATE(),
                @insertsaldo,
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
                @saldoTotal + @insertsaldo,
                --saldo
                @saldoPremio,
                --saldoPremio + @insertsaldo,
                @saldoCredito + @insertsaldo,
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
                SaldoCredito = @insertsaldo,
                SaldoPremio = @insertsaldo,
                SaldoTotal = @insertsaldo
            WHERE
                IdUsuario = @id;
        END;")
  end

  def insert_account(idUsuario)
    @connection.execute(
      "DECLARE @idUsuario AS INTEGER=#{idUsuario}

        INSERT INTO UsuarioContaCorrente( idUsuario, idBanco, agenciaNumero, agenciaDigito,
        contaNumero, contaDigito, cpf, nomeTitular,
        idTipoConta, ativo, favorito,  idUsuarioCriacao
        )
        VALUES(@idUsuario, 1, 1234, 1,
        '0987654328', 1, 66530420061, 'Otto Oliveira Junior',
        1, 1, 0,  @idUsuario
        )"
    )
  end

  def delete_account(id_user)
    @connection.execute(
      "DECLARE @idUsuario AS INTEGER=#{id_user}

      DELETE
      FROM ResgateStatus
      WHERE idResgate
      IN (
      SELECT idResgate
      FROM Resgate
      WHERE idUsuario
      IN (
      SELECT idUsuario FROM UsuarioContaCorrente WHERE idUsuario = @idUsuario
        )
      )

      DELETE
      FROM Resgate
      WHERE idUsuario
      IN (
      SELECT idUsuario FROM UsuarioContaCorrente WHERE idUsuario = @idUsuario
      )

      DELETE FROM UsuarioContaCorrente WHERE idUsuarioCriacao = @idUsuario"
    )
  end
end
