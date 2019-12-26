# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiResgate
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'


  def self.post_SetResgate(valor, token, agenciaNumero, agenciaDigito,contaNumero, contaDigito)
    headers['Authorization'] = token

    @SetResgate = {
        "obj": {
            "valor": valor,
            "idBanco": 1,
            "idTipoConta": "1",
            "agenciaNumero": agenciaNumero,
            "agenciaDigito": agenciaDigito,
            "contaNumero": contaNumero,
            "contaDigito": contaDigito,
            "cpf": "44302702010",
            "nomeTitular": "grazi a"
        }
    }
    post('/Pagamento/SetResgate', body: @SetResgate.to_json)
  end

  def self.get_StatusResgate(token)
    headers['Authorization'] = token
    get('/Usuario/GetDadosUsuarioParaResgate', body: @StatusResgate.to_json)
  end
end

