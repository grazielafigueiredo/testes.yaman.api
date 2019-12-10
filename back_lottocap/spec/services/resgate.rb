# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiResgate
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'


  def self.post_ResgateSucesso(valor, token)
    headers['Authorization'] = token

    @ResgateSucesso = {
        "obj": {
            "valor": valor,
            "idBanco": 1,
            "idTipoConta": "1",
            "agenciaNumero": Faker::Bank.account_number(digits: 4),
            "agenciaDigito": Faker::Bank.account_number(digits: 1),
            "contaNumero": Faker::Bank.account_number(digits: 10),
            "contaDigito": Faker::Bank.account_number(digits: 1),
            "cpf": "44302702010",
            "nomeTitular": "grazi a"
        }
    }
    post('/Pagamento/SetResgate', body: @ResgateSucesso.to_json)
  end

  def self.get_StatusResgate()
    # headers['Authorization'] = token
    get('/Usuario/GetDadosUsuarioParaResgate', body: @StatusResgate.to_json)
  end
end

