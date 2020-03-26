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


  def self.post_PagarCartaoDeCredito(token, idCarrinho, nomeCompletoTitular, ccredNumero, ccredValidadeMes, ccredValidadeAno, ccredCVV)
    headers['Authorization'] = token

    @PagarCartaoDeCredito = {
      "obj": {
        "idFormaPagamento": 5,
        "idCarrinho": idCarrinho,
        "nomeCompletoTitular": nomeCompletoTitular,
        "ccredNumero": ccredNumero,
        "ccredValidadeMes": ccredValidadeMes,
        "ccredValidadeAno": ccredValidadeAno,
        "ccredCVV": ccredCVV
      }
    }
    post('/Pagamento/PagarCarrinho', body: @PagarCartaoDeCredito.to_json)
  end

  # def self.post_AdicionarCartaoDeCredito(token, idCarrinho, nomeCompletoTitular, ccredNumero, ccredValidadeMes, ccredValidadeAno, ccredCVV)
  #   headers['Authorization'] = token

  #   @AdicionarCartaoDeCredito = {
  #     "obj": {
  #       "idFormaPagamento": 5,
  #       "idCarrinho": idCarrinho,
  #       "nomeCompletoTitular": nomeCompletoTitular,
  #       "ccredNumero": ccredNumero,
  #       "ccredValidadeMes": ccredValidadeMes,
  #       "ccredValidadeAno": ccredValidadeAno,
  #       "ccredCVV": ccredCVV
  #     }
  #   }
  #   post('/Pagamento/AdicionarCartaoDeCredito', body: @AdicionarCartaoDeCredito.to_json)
  # end
end
