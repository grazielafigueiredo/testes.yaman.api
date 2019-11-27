# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiPagamento
  include HTTParty
  base_uri 'https://hmlapi.lottocap.com.br/api/Pagamento'
  headers 'Content-Type' => 'application/json'

  def self.post_ObterFormasPagamentoDisponiveis(token, idCarrinho)
    headers['Authorization'] = token
    
    @ObterFormasPagamentoDisponiveis = {
      "obj": {
        "idCarrinho": idCarrinho,
        "flCompraDeCredito": false
      }
    }

    post('/ObterFormasPagamentoDisponiveis', body: @ObterFormasPagamentoDisponiveis.to_json)
  end

  # ------------ Cartão de Crédito -----------------------


  def self.post_AdicionarCartaoDeCreditoSucesso(token, idCarrinho)
    headers['Authorization'] = token

    ApiCarrinho.get_GetStatusCarrinho
    @AdicionarCartaoDeCreditoSucesso = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": idCarrinho,
        "nomeCompletoTitular": Constant::NomeCompletoTitular,
        "ccredNumero": Constant::NumeroCartao,
        "ccredValidadeMes": Constant::ValidadeMesCartao,
        "ccredValidadeAno": Constant::ValidadeAnoCartao,
        "ccredCVV": Constant::CartaoCVV
      }
    }
    post('/PagarCarrinho', body: @AdicionarCartaoDeCreditoSucesso.to_json)
  end


  def self.post_NumeroCartaoDeCreditoInvalido(ccredNumero, token, idCarrinho)
    headers['Authorization'] = token

    @NumeroCartaoDeCreditoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": idCarrinho,
        "nomeCompletoTitular": Constant::NomeCompletoTitular,
        "ccredNumero": ccredNumero,
        "ccredValidadeMes": Constant::ValidadeMesCartao,
        "ccredValidadeAno": Constant::ValidadeAnoCartao,
        "ccredCVV": Constant::CartaoCVV
      }
    }
    post('/PagarCarrinho', body: @NumeroCartaoDeCreditoInvalido.to_json)
  end

  def self.post_NomeCartaoDeCreditoInvalido(nomeCompletoTitular, token, idCarrinho)
    headers['Authorization'] = token

    @NomeCartaoDeCreditoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": idCarrinho,
        "nomeCompletoTitular": nomeCompletoTitular,
        "ccredNumero": Constant::NumeroCartao,
        "ccredValidadeMes": Constant::ValidadeMesCartao,
        "ccredValidadeAno": Constant::ValidadeAnoCartao,
        "ccredCVV": Constant::CartaoCVV
      }
    }
    post('/PagarCarrinho', body: @NomeCartaoDeCreditoInvalido.to_json)
  end

  def self.post_MesCartaoDeCreditoInvalido(ccredValidadeMes, token, idCarrinho)
    headers['Authorization'] = token

    @MesCartaoDeCreditoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": idCarrinho,
        "nomeCompletoTitular": Constant::NomeCompletoTitular,
        "ccredNumero": Constant::NumeroCartao,
        "ccredValidadeMes": ccredValidadeMes,
        "ccredValidadeAno": Constant::ValidadeAnoCartao,
        "ccredCVV": Constant::CartaoCVV
      }
    }
    post('/PagarCarrinho', body: @MesCartaoDeCreditoInvalido.to_json)
  end

  def self.post_AnoCartaoDeCreditoInvalido(ccredValidadeAno, token, idCarrinho)
    headers['Authorization'] = token

    @AnoCartaoDeCreditoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": idCarrinho,
        "nomeCompletoTitular": Constant::NomeCompletoTitular,
        "ccredNumero": Constant::NumeroCartao,
        "ccredValidadeMes": Constant::ValidadeMesCartao,
        "ccredValidadeAno": ccredValidadeAno,
        "ccredCVV": Constant::CartaoCVV
      }
    }
    post('/PagarCarrinho', body: @AnoCartaoDeCreditoInvalido.to_json)
  end

  def self.post_CVVCartaoDeCreditoInvalido(ccredCVV, token, idCarrinho)
    headers['Authorization'] = token

    @CVVCartaoDeCreditoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": idCarrinho,
        "nomeCompletoTitular": Constant::NomeCompletoTitular,
        "ccredNumero": Constant::NumeroCartao,
        "ccredValidadeMes": Constant::ValidadeMesCartao,
        "ccredValidadeAno": Constant::ValidadeAnoCartao,
        "ccredCVV": ccredCVV
      }
    }
    post('/PagarCarrinho', body: @CVVCartaoDeCreditoInvalido.to_json)
  end
end
