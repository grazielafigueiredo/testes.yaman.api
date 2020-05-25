# frozen_string_literal: true

class UserModel
  attr_accessor :nomeCompleto, :dataNascimento, :cpf, :email,
                :aceitaReceberMensagemDeMarketingPorEmail, :aceitaOsTermosECondicoesDeUso,
                :cdPromocaoUsuario, :senha, :metodo_de_cadastro

  def to_hash
    {
      nomeCompleto: @nomeCompleto,
      dataNascimento: @dataNascimento,
      cpf: @cpf,
      email: @email,
      aceitaReceberMensagemDeMarketingPorEmail: @aceitaReceberMensagemDeMarketingPorEmail,
      aceitaOsTermosECondicoesDeUso: @aceitaOsTermosECondicoesDeUso,
      cdPromocaoUsuario: @cdPromocaoUsuario,
      senha: @senha,
      metodo_de_cadastro: @metodo_de_cadastro
    }
  end
end

class ValidationUserModel
  attr_accessor :nomeCompleto, :cpf, :email

  def to_hash
    {
      nomeCompleto: @nomeCompleto,
      email: @email,
      cpf: @cpf
    }
  end
end

class ChangeUserModel
  attr_accessor :apelido, :nomeCompleto, :email, :cpf, :idNacionalidade,
                :sexo, :telefoneDDD, :telefoneNumero,  :cep, :dataNascimento, :enderecoLogradouro,
                :enderecoNumero, :enderecoComplemento, :enderecoBairro, :enderecoCidade,
                :enderecoEstado, :PEP, :nmPEP, :cargoPEP, :parentescoPEP

  def to_hash
    {
      apelido: @apelido,
      nomeCompleto: @nomeCompleto,
      email: @email,
      cpf: @cpf,
      idNacionalidade: @idNacionalidade,
      sexo: @sexo,
      telefoneDDD: @telefoneDDD,
      telefoneNumero: @telefoneNumero,
      cep: @cep,
      dataNascimento: @dataNascimento,
      enderecoLogradouro: @enderecoLogradouro,
      enderecoNumero: @enderecoNumero,
      enderecoComplemento: @enderecoComplemento,
      enderecoBairro: @enderecoBairro,
      enderecoCidade: @enderecoCidade,
      enderecoEstado: @enderecoEstado,
      PEP: @PEP,
      nmPEP: @nmPEP,
      cargoPEP: @cargoPEP,
      parentescoPEP: @parentescoPEP
    }
  end
end
