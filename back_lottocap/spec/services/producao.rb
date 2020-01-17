# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiProducao
  include HTTParty
  base_uri "https://api.lottocap.com.br/api"
  headers 'Content-Type' => 'application/json'

  def self.post_CadastrarUsuario(token, nomeCompleto, cpf, email)
    headers['Authorization'] = token

    @createUser = {
      "obj": {
        "nomeCompleto": nomeCompleto,
        "dataNascimento": '1997-01-01T00:00:00-03:00',
        "cpf": cpf,
        "email": email,
        "aceitaReceberMensagemDeMarketingPorEmail": false,
        "aceitaOsTermosECondicoesDeUso": true,
        # "cdPromocaoUsuario": null,
        "senha": '1234',
        "metodo_de_cadastro": 'email'
      }
    }
    post('/Usuario/CadastrarUsuario', body: @createUser.to_json)
  end

  def self.post_validarDadosUsuarioCriacao(token, nomeCompleto, cpf, email)
    headers['Authorization'] = token

    @validarUser = {
      "obj": {
        "nomeCompleto": nomeCompleto,
        "email": email,
        "cpf": cpf
      },
      "atualPagina": 0,
      "tamanhoPagina": 0
    }
    post('/Usuario/ValidarDadosUsuarioCriacao', body: @validarUser.to_json)
  end

  def self.post_AlterarDadosUsuario(token, email, cpf)
    headers['Authorization'] = token

    @AlterarDadosUsuario = {
      "obj": {
        "apelido": 'grazi',
        "nomeCompleto": 'grazi a',
        "email": email,
        "cpf": cpf,
        "idNacionalidade": 32,
        "sexo": 3,
        "telefoneDDD": '11',
        "telefoneNumero": '23456789',
        "cep": '06160000',
        "dataNascimento": '1995-01-01T00:00:00-02:00',
        "enderecoLogradouro": 'Avenida Benedito Alves Turíbio',
        "enderecoNumero": '7777',
        "enderecoComplemento": 'até 501/502',
        "enderecoBairro": 'Padroeira',
        "enderecoCidade": 'Osasco',
        "enderecoEstado": 'SP',
        "PEP": false,
        "nmPEP": '',
        "cargoPEP": '',
        "parentescoPEP": ''
      },
      "atualPagina": 0,
      "tamanhoPagina": 0
    }
    post('/Usuario/AlterarDadosUsuario', body: @AlterarDadosUsuario.to_json)
  end

  def self.find
    # headers[:Authorization] = self.GetToken()

    @user = { "obj": { "usuario": 'graziela@lottocap.com.br', "senha": 'lottocap' } }

    response_in_json = JSON.parse(get('/Usuario/GerarToken').response.body)
    token = response_in_json['dadosUsuario']['token']

    headers[:Authorization] = token
    post('/Usuario/LogarUsuario', body: @user.to_json, headers: headers)

    token
  end

  def self.Login(token, user)
    @user = { "obj": user }

    headers[:Authorization] = token

    post('/Usuario/LogarUsuario', body: @user.to_json, headers: headers)
  end

  def self.GetToken
    response_in_json = JSON.parse(get('/Usuario/GerarToken').response.body)

    token = response_in_json['dadosUsuario']['token']

    token
  end

  def self.get_deslogar(token)
    headers[:Authorization] = token

    get('/Usuario/DeslogarUsuario', headers: headers)
  end
end

class Token
  include Singleton

  def initialize
    @token = ApiProducao.GetToken()
  end

  def get
    @token
  end
end
