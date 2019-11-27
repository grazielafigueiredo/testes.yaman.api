# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiPagamento
  include HTTParty
  base_uri 'https://hmlapi.lottocap.com.br/api/Pagamento'
  headers 'Content-Type' => 'application/json', 'Authorization' => Constant::Authorization
  # Token.instance.get

  def self.post_ObterFormasPagamentoDisponiveis
    @ObterFormasPagamentoDisponiveis = {
      "obj": {
        "idCarrinho": Constant::IdCarrinho,
        "flCompraDeCredito": false
      }
    }

    post('/ObterFormasPagamentoDisponiveis', body: @ObterFormasPagamentoDisponiveis.to_json)
  end

  def self.post_ObterFormasPagamentoDisponiveisParametrizado(token, idCarrinho)
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

  def self.post_AdicionarCartaoDeCreditoSucesso
    @AdicionarCartaoDeCreditoSucesso = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": Constant::IdCarrinho,
        "nomeCompletoTitular": Constant::NomeCompletoTitular,
        "ccredNumero": Constant::NumeroCartao,
        "ccredValidadeMes": Constant::ValidadeMesCartao,
        "ccredValidadeAno": Constant::ValidadeAnoCartao,
        "ccredCVV": Constant::CartaoCVV
      }
    }
    post('/PagarCarrinho', body: @AdicionarCartaoDeCreditoSucesso.to_json)
  end

  def self.post_AdicionarCartaoDeCreditoSucessoParametrizado(token, idCarrinho)
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


  def self.post_NumeroCartaoDeCreditoInvalido(ccredNumero)
    @NumeroCartaoDeCreditoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": Constant::IdCarrinho,
        "nomeCompletoTitular": Constant::NomeCompletoTitular,
        "ccredNumero": ccredNumero,
        "ccredValidadeMes": Constant::ValidadeMesCartao,
        "ccredValidadeAno": Constant::ValidadeAnoCartao,
        "ccredCVV": Constant::CartaoCVV
      }
    }
    post('/PagarCarrinho', body: @NumeroCartaoDeCreditoInvalido.to_json)
  end

  def self.post_NomeCartaoDeCreditoInvalido(nomeCompletoTitular)
    @NomeCartaoDeCreditoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": Constant::IdCarrinho,
        "nomeCompletoTitular": nomeCompletoTitular,
        "ccredNumero": Constant::NumeroCartao,
        "ccredValidadeMes": Constant::ValidadeMesCartao,
        "ccredValidadeAno": Constant::ValidadeAnoCartao,
        "ccredCVV": Constant::CartaoCVV
      }
    }
    post('/PagarCarrinho', body: @NomeCartaoDeCreditoInvalido.to_json)
  end

  def self.post_MesCartaoDeCreditoInvalido(ccredValidadeMes)
    @MesCartaoDeCreditoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": Constant::IdCarrinho,
        "nomeCompletoTitular": Constant::NomeCompletoTitular,
        "ccredNumero": Constant::NumeroCartao,
        "ccredValidadeMes": ccredValidadeMes,
        "ccredValidadeAno": Constant::ValidadeAnoCartao,
        "ccredCVV": Constant::CartaoCVV
      }
    }
    post('/PagarCarrinho', body: @MesCartaoDeCreditoInvalido.to_json)
  end

  def self.post_AnoCartaoDeCreditoInvalido(ccredValidadeAno)
    @AnoCartaoDeCreditoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": Constant::IdCarrinho,
        "nomeCompletoTitular": Constant::NomeCompletoTitular,
        "ccredNumero": Constant::NumeroCartao,
        "ccredValidadeMes": Constant::ValidadeMesCartao,
        "ccredValidadeAno": ccredValidadeAno,
        "ccredCVV": Constant::CartaoCVV
      }
    }
    post('/PagarCarrinho', body: @AnoCartaoDeCreditoInvalido.to_json)
  end

  def self.post_CVVCartaoDeCreditoInvalido(ccredCVV)
    @CVVCartaoDeCreditoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamento,
        "idCarrinho": Constant::IdCarrinho,
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
