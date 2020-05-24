# frozen_string_literal: true

require_relative '../models/user_model'

FactoryBot.define do
  factory :user, class: UserModel do
    nomeCompleto { 'Otto Oliveira' }
    dataNascimento { '1997-01-01T00:00:00-03:00' }
    # cpf { '00000002054' }
    # email { 'alo@gmail.com' }
    cpf { Faker::CPF.numeric }
    email { Faker::Internet.email }
    aceitaReceberMensagemDeMarketingPorEmail { false }
    aceitaOsTermosECondicoesDeUso { true }
    cdPromocaoUsuario { nil }
    senha { '1234' }
    metodo_de_cadastro { 'email' }

    after(:build) do |user|
      User.new.delete_user(user.email)
    end
  end

  factory :user_wrong_email, class: UserModel do
    nomeCompleto { 'Otto Oliveira' }
    dataNascimento { '1997-01-01T00:00:00-03:00' }
    cpf { Faker::CPF.numeric }
    email { 'alo@gmail.com' }
    aceitaReceberMensagemDeMarketingPorEmail { false }
    aceitaOsTermosECondicoesDeUso { true }
    cdPromocaoUsuario { nil }
    senha { '1234' }
    metodo_de_cadastro { 'email' }
  end

  factory :user_wrong_cpf, class: UserModel do
    nomeCompleto { 'Otto Oliveira' }
    dataNascimento { '1997-01-01T00:00:00-03:00' }
    cpf { '00000000000' }
    email { 'alo@gmail.com' }
    aceitaReceberMensagemDeMarketingPorEmail { false }
    aceitaOsTermosECondicoesDeUso { true }
    cdPromocaoUsuario { nil }
    senha { '1234' }
    metodo_de_cadastro { 'email' }
  end

  factory :user_validation, class: ValidationUserModel do
    nomeCompleto { 'Otto Oliveira' }
    email { Faker::Internet.email }
    cpf { Faker::CPF.numeric }

    after(:build) do |user|
      User.new.delete_user(user.email)
    end
  end

  factory :user_validation_wrong_cpf, class: ValidationUserModel do
    nomeCompleto { 'Otto Oliveira' }
    email { Faker::Internet.email }
    cpf { '00000000000' }
  end

  factory :user_validation_register_cpf, class: ValidationUserModel do
    nomeCompleto { 'Otto Oliveira' }
    email { Faker::Internet.email }
    cpf { '00000009652' }
  end

  factory :user_validation_register_email, class: ValidationUserModel do
    nomeCompleto { 'Otto Oliveira' }
    email { 'alo@gmail.com' }
    cpf { Faker::CPF.numeric }
  end

  factory :change_user, class: ChangeUserModel do
    apelido { 'grazi' }
    nomeCompleto { 'grazi a' }
    email { 'otto@gmail.com' }
    cpf { '00000009652' }
    idNacionalidade { 32 }
    sexo { 3 }
    telefoneDDD { '11' }
    telefoneNumero { '23456789' }
    cep { '06160000' }
    dataNascimento { '1995-01-01T00:00:00-02:00' }
    enderecoLogradouro { 'Avenida Benedito Alves Turíbio' }
    enderecoNumero { '7777' }
    enderecoComplemento { 'até 501/502' }
    enderecoBairro { 'Padroeira' }
    enderecoCidade { 'Osasco' }
    enderecoEstado { 'SP' }
    PEP { false }
    nmPEP { '' }
    cargoPEP { '' }
    parentescoPEP { '' }
  end

  factory :change_user_email, class: ChangeUserModel do
    apelido { 'grazi' }
    nomeCompleto { 'grazi a' }
    email { 'graziela@gmail.com.br' }
    cpf { '00000009652' }
    idNacionalidade { 32 }
    sexo { 3 }
    telefoneDDD { '11' }
    telefoneNumero { '23456789' }
    cep { '06160000' }
    dataNascimento { '1995-01-01T00:00:00-02:00' }
    enderecoLogradouro { 'Avenida Benedito Alves Turíbio' }
    enderecoNumero { '7777' }
    enderecoComplemento { 'até 501/502' }
    enderecoBairro { 'Padroeira' }
    enderecoCidade { 'Osasco' }
    enderecoEstado { 'SP' }
    PEP { false }
    nmPEP { '' }
    cargoPEP { '' }
    parentescoPEP { '' }
  end

  factory :change_user_cpf, class: ChangeUserModel do
    apelido { 'grazi' }
    nomeCompleto { 'grazi a' }
    email { Faker::Internet.email }
    cpf { '0000000000' }
    idNacionalidade { 32 }
    sexo { 3 }
    telefoneDDD { '11' }
    telefoneNumero { '23456789' }
    cep { '06160000' }
    dataNascimento { '1995-01-01T00:00:00-02:00' }
    enderecoLogradouro { 'Avenida Benedito Alves Turíbio' }
    enderecoNumero { '7777' }
    enderecoComplemento { 'até 501/502' }
    enderecoBairro { 'Padroeira' }
    enderecoCidade { 'Osasco' }
    enderecoEstado { 'SP' }
    PEP { false }
    nmPEP { '' }
    cargoPEP { '' }
    parentescoPEP { '' }
  end

  factory :change_user_cpf_registered, class: ChangeUserModel do
    apelido { 'grazi' }
    nomeCompleto { 'grazi a' }
    email { Faker::Internet.email }
    cpf { '0000009652' }
    idNacionalidade { 32 }
    sexo { 3 }
    telefoneDDD { '11' }
    telefoneNumero { '23456789' }
    cep { '06160000' }
    dataNascimento { '1995-01-01T00:00:00-02:00' }
    enderecoLogradouro { 'Avenida Benedito Alves Turíbio' }
    enderecoNumero { '7777' }
    enderecoComplemento { 'até 501/502' }
    enderecoBairro { 'Padroeira' }
    enderecoCidade { 'Osasco' }
    enderecoEstado { 'SP' }
    PEP { false }
    nmPEP { '' }
    cargoPEP { '' }
    parentescoPEP { '' }
  end
end
