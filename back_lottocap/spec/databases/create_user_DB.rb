# frozen_string_literal: true

require_relative 'db_base'

class User < DbBase
  def delete_user(email)
    delete_user = @connection.execute(
      "DELETE
      FROM Pessoa
      WHERE idUsuario
      IN (
      SELECT idUsuario FROM Usuario WHERE Email = '#{email}'
      )
      DELETE FROM Usuario WHERE Email = '#{email}'"
    )
    delete_user.do
  end

  def update_user_email(email)
    @connection.execute(
      "UPDATE Usuario
      SET Email = 'user22@gmail.com'
      WHERE Email = '#{email}'"
    )
  end

  def delete_user_email(email)
    puts email
    delete_user = @connection.execute(
      "
      DECLARE @email AS VARCHAR(50) = #{email}

      DELETE
      FROM LogTransacao WHERE idUsuarioCriacao
      IN (
          SELECT idUsuario FROM Usuario WHERE Email = @email
      )
      
      DELETE
      FROM Pessoa WHERE idUsuario
      IN (
          SELECT idUsuario FROM Usuario WHERE Email = @email
      )
      
      DELETE 
      FROM ReservaTituloToken WHERE IdToken
      IN (
          SELECT IdToken FROM TokenUsuario WHERE IdUsuario
          IN (
              SELECT idUsuario FROM Usuario WHERE Email = @email
          )
      )
      
      DELETE 
      FROM ReservaTokenTituloMatriz WHERE IdToken
      IN (
          SELECT IdToken FROM TokenUsuario WHERE IdUsuario
          IN (
              SELECT IdUsuario FROM TokenUsuario WHERE IdUsuario
              IN (
                  SELECT idUsuario FROM Usuario WHERE Email = @email
              )
          )
      )
      
      DELETE 
      FROM TokenUsuario WHERE IdUsuario
      IN (
          SELECT IdUsuario FROM CarrinhoToken WHERE IdToken
          IN (
              SELECT IdToken FROM TokenUsuario WHERE IdUsuario
              IN (
                  SELECT idUsuario FROM Usuario WHERE Email = @email
              )
          )
      )
      
      DELETE 
      FROM TokenUsuario WHERE IdUsuario
      IN (
          SELECT idUsuario FROM Usuario WHERE Email = @email
      )
      
      DELETE 
      FROM CarrinhoItem WHERE IdCarrinho
      IN (
      SELECT IdCarrinho FROM Carrinho WHERE IdUsuarioCriacao
          IN(
              SELECT idUsuario FROM Usuario WHERE Email = @email
          )   
      )
      
      DELETE 
      FROM Carrinho WHERE IdUsuarioCriacao
      IN(
          SELECT idUsuario FROM Usuario WHERE Email = @email
      )
      
      DELETE 
      FROM Usuario WHERE Email = @email
      "
    )
    delete_user.do
  end

  def insert_first_access_user(idUsuario)
    firt_user = @connection.execute(
      "DECLARE @idUser AS INTEGER=#{idUsuario}

      UPDATE Pessoa SET DataAlteracao = NULL, IdUsuarioAlteracao = @idUser, telefoneDDD = 11, telefoneNumero = 999999999, enderecoLogradouro = 'Rua Ceará',
      enderecoNumero = 123, enderecoComplemento = NULL, enderecoBairro = 'Funcionários', enderecoCidade = 'São Paulo', enderecoEstado = 'SP',
      CEP = 04302090 WHERE IdUsuario = @idUser

      UPDATE Usuario SET FlagDadosBasicos = 1, FlagDadosCompletos = 1 WHERE IdUsuario = @idUser"
    )
    firt_user.do
  end
end
