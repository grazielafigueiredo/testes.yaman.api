# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiResgate
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'


  def self.post_setResgate(valor, token, idBanco, agenciaNumero, agenciaDigito,contaNumero, contaDigito)
    headers['Authorization'] = token

    @setResgate = {
        "obj": {
            "valor": valor,
            "idBanco": idBanco,
            "idTipoConta": "1",
            "agenciaNumero": agenciaNumero,
            "agenciaDigito": agenciaDigito,
            "contaNumero": contaNumero,
            "contaDigito": contaDigito,
            "cpf": "44302702010",
            "nomeTitular": "grazi a"
        }
    }
    post('/Pagamento/SetResgate', body: @setResgate.to_json)
  end

  def self.get_statusResgate(token)
    headers['Authorization'] = token
    get('/Usuario/GetDadosUsuarioParaResgate', body: @statusResgate.to_json)
  end
end

