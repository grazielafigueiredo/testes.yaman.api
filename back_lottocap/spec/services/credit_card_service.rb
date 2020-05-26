# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiCartao
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.post_ObterFormasPagamentoDisponiveis(token, idCarrinho)
    headers['Authorization'] = token

    @ObterFormasPagamentoDisponiveis = {
      "obj": {
        "idCarrinho": idCarrinho,
        "flCompraDeCredito": false
      }
    }

    post('/Pagamento/ObterFormasPagamentoDisponiveis', body: @ObterFormasPagamentoDisponiveis.to_json)
  end

  # ------------ Cartão de Crédito -----------------------

  def self.post_credit_card(token, idCarrinho, credit_card)
    headers['Authorization'] = token
    credit_card[:idCarrinho] = idCarrinho
    payload = { "obj": credit_card }
    post('/Pagamento/PagarCarrinho', body: payload.to_json)
  end
end
