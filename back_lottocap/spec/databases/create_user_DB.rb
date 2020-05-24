# frozen_string_literal: true

require_relative 'db_base'

class User < DbBase
  def delete_user(email)
    @connection.execute(
      "DELETE
      FROM Pessoa
      WHERE idUsuario
      IN (
      SELECT idUsuario FROM Usuario WHERE Email = '#{email}'
      )
      DELETE FROM Usuario WHERE Email = '#{email}'"
    )
  end

  def update_user_email(email)
    @connection.execute(
      "UPDATE Usuario
      SET Email = 'user22@gmail.com'
      WHERE Email = '#{email}'"
    )
  end
end
