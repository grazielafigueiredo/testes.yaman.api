# frozen_string_literal: true

require 'utils/constant'

class ApiCreateUser
  include HTTParty
  base_uri 'https://hmlapi.lottocap.com.br/api'
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

    def self.post_ValidarDadosUsuarioCriacao(token, nomeCompleto, cpf, email)
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

    def self.post_AlterarDadosUsuario(token)
        headers['Authorization'] = token

        @AlterarDadosUsuario = {
            "obj": {
                "apelido": "grazi",
                "nomeCompleto": "grazi a",
                "email": "user22@gmail.com",
                "cpf": "44302702010",
                "idNacionalidade": 32,
                "sexo": 3,
                "telefoneDDD": "11",
                "telefoneNumero": "23456789",
                "cep": "06160000",
                "dataNascimento": "1995-01-01T00:00:00-02:00",
                "enderecoLogradouro": "Avenida Benedito Alves Turíbio",
                "enderecoNumero": "7777",
                "enderecoComplemento": "até 501/502",
                "enderecoBairro": "Padroeira",
                "enderecoCidade": "Osasco",
                "enderecoEstado": "SP",
                "PEP": false,
                "nmPEP": "",
                "cargoPEP": "",
                "parentescoPEP": ""
            },
            "atualPagina": 0,
            "tamanhoPagina": 0
        }
        post('/Usuario/AlterarDadosUsuario', body: @AlterarDadosUsuario.to_json)
    end
end
