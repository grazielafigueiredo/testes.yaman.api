# frozen_string_literal: true

class TransferDB < DbBase
  def insert_account(idUsuario)
    @connection.execute(
      "DECLARE @idUsuario AS INTEGER=#{idUsuario}

        ----BRADESCO---
        INSERT INTO UsuarioContaCorrente( idUsuario, idBanco, agenciaNumero, agenciaDigito,
        contaNumero, contaDigito, cpf, nomeTitular,
        idTipoConta, ativo, favorito, dtCriacao, idUsuarioCriacao
        )
        VALUES(@idUsuario, 1, 4242, NULL,
        1120, 0, 66530420061, 'Otto Oliveira Junior',
        0, 1, 0, 0, 0
        )

        ----ITAU---
        INSERT INTO UsuarioContaCorrente( idUsuario, idBanco, agenciaNumero, agenciaDigito,
        contaNumero, contaDigito, cpf, nomeTitular,
        idTipoConta, ativo, favorito, dtCriacao, idUsuarioCriacao
        )
        VALUES(@idUsuario, 2, 4242, 4,
        1120, 7, 66530420061, 'Otto Oliveira Junior',
        0, 1, 0, 0, 0
        )

        ----SANTANDER---
        INSERT INTO UsuarioContaCorrente( idUsuario, idBanco, agenciaNumero, agenciaDigito,
        contaNumero, contaDigito, cpf, nomeTitular,
        idTipoConta, ativo, favorito, dtCriacao, idUsuarioCriacao
        )
        VALUES(@idUsuario, 3, NULL, NULL,
        NULL, NULL, 66530420061, 'Otto Oliveira Junior',
        0, 1, 0, 0, 0
        )

        ----BBRASIL---
        INSERT INTO UsuarioContaCorrente( idUsuario, idBanco, agenciaNumero, agenciaDigito,
        contaNumero, contaDigito, cpf, nomeTitular,
        idTipoConta, ativo, favorito, dtCriacao, idUsuarioCriacao
        )
        VALUES(@idUsuario, 5, 8080, 7,
        5966, 8, 66530420061, 'Otto Oliveira Junior',
        0, 1, 0, 0, 0
        )"
    )
  end

  def delete_account(idUsuario)
    @connection.execute(
      "DECLARE @idUsuario AS INTEGER=#{idUsuario}
      DELETE
      FROM Resgate
      WHERE idUsuario
      IN (
      SELECT idUsuario FROM UsuarioContaCorrente WHERE idUsuario = @idUsuario
      )
      DELETE FROM UsuarioContaCorrente WHERE idUsuario = @idUsuario"
    )
  end
end
