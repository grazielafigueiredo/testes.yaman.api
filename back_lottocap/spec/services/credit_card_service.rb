# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiCartao
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.post_ObterFormasPagamentoDisponiveis(token, idCarrinho)

    @ObterFormasPagamentoDisponiveis = {
      "obj": {
        "idCarrinho": idCarrinho,
        "flCompraDeCredito": false
      }
    }

    post('/Pagamento/ObterFormasPagamentoDisponiveis', body: @ObterFormasPagamentoDisponiveis.to_json, headers: { 'Authorization' => token })
  end

  # ------------ Cartão de Crédito -----------------------

  def self.post_credit_card(token, idCarrinho, credit_card)
    credit_card[:idCarrinho] = idCarrinho
    payload = { "obj": credit_card }
    post('/Pagamento/PagarCarrinho', body: payload.to_json, headers: { 'Authorization' => token })
  end
end
