# frozen_string_literal: true

require 'utils/constant'

class ApiCreateUser
  include HTTParty
  base_uri 'https://hmlapi.lottocap.com.br/api'
  headers 'Content-Type' => 'application/json'

    def self.post_createUser(token, nomeCompleto, cpf, email)
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
end
