# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiTransferencia
  include HTTParty
  base_uri 'https://hmlapi.lottocap.com.br/api/Pagamento'
  headers 'Content-Type' => 'application/json', 'Authorization' => Constant::Authorization

  # ------------ Transferência Bancária (Bradesco)-----------------------

  def self.post_TransfSucessoBradesco
    @TransfSucessoBradesco = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransf,
        "idCarrinho": Constant::IdCarrinho,
        "transfAgencia": Constant::TransfAgencia,
        "transfConta": Constant::TransfConta,
        "transfContaDigito": Constant::TransfContaDigito,
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/PagarCarrinho', body: @TransfSucessoBradesco.to_json)
  end

  def self.post_TransfContaInvalida(transfConta)
    @TransfContaInvalida = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransf,
        "idCarrinho": Constant::IdCarrinho,
        "transfAgencia": Constant::TransfAgencia,
        "transfConta": transfConta,
        "transfContaDigito": Constant::TransfContaDigito,
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/PagarCarrinho', body: @TransfContaInvalida.to_json)
  end

  def self.post_TransfDigitoInvalido(_transfContaDigito)
    @TransfDigitoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransf,
        "idCarrinho": Constant::IdCarrinho,
        "transfAgencia": Constant::TransfAgencia,
        "transfConta": Constant::TransfConta,
        "transfContaDigito": '',
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/PagarCarrinho', body: @TransfDigitoInvalido.to_json)
  end

  def self.post_TransfNomeNull
    @TransfNomeNull = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransf,
        "idCarrinho": Constant::IdCarrinho,
        "transfAgencia": Constant::TransfAgencia,
        "transfConta": Constant::TransfConta,
        "transfContaDigito": Constant::TransfContaDigito,
        "nomeCompletoTitular": ''

      }
    }
    post('/PagarCarrinho', body: @TransfNomeNull.to_json)
  end

  def self.post_TransfAgenciaInvalida(transfAgencia)
    @TransfAgenciaInvalida = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransf,
        "idCarrinho": Constant::IdCarrinho,
        "transfAgencia": transfAgencia,
        "transfConta": Constant::TransfConta,
        "transfContaDigito": Constant::TransfContaDigito,
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/PagarCarrinho', body: @TransfAgenciaInvalida.to_json)
  end

  # ------------ Transferência Bancária (Itau)-----------------------

  def self.post_TransfSucessoItau
    @TransfSucessoItau = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransfItau,
        "idCarrinho": Constant::IdCarrinho,
        "transfAgencia": Constant::TransfAgencia,
        "transfAgenciaDigito": '',
        "transfConta": Constant::TransfConta,
        "transfContaDigito": Constant::TransfContaDigito,
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/PagarCarrinho', body: @TransfSucessoItau.to_json)
    end

  # ------------ Transferência Bancária (Santander)-----------------------

  def self.post_TransfSucessoSantander
    @TransfSucessoSantander = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransfSantander,
        "idCarrinho": Constant::IdCarrinho,
        "cpf": Constant::Cpf

      }
    }
    post('/PagarCarrinho', body: @TransfSucessoSantander.to_json)
  end

  def self.post_TransfSantanderInvalido(cpf)
    @TransfSucessoSantander = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransfSantander,
        "idCarrinho": Constant::IdCarrinho,
        "cpf": cpf

      }
    }
    post('/PagarCarrinho', body: @TransfSucessoSantander.to_json)
  end

  # ------------ Transferência Bancária (Brasil)-----------------------

  def self.post_TransfSucessoBrasil
    @TransfSucessoBrasil = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransfBrasil,
        "idCarrinho": Constant::IdCarrinho,
        "transfAgencia": Constant::TransfAgencia,
        "transfAgenciaDigito": Constant::TransfAgenciaDigito,
        "transfConta": Constant::TransfConta,
        "transfContaDigito": Constant::TransfContaDigito,
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/PagarCarrinho', body: @TransfSucessoBrasil.to_json)
  end
  # def self.post_AdicionarContaBancaria()

  #     @AdicionarContaBancaria =

  #     post("/AdicionarContaBancaria", body: @AdicionarContaBancaria.to_json)
  # end

  # def self.post_GetStatusPagamento()

  #     @GetStatusPagamento =

  #     post("/GetStatusPagamento", body: @GetStatusPagamento.to_json)
  # end

  # def self.post_SetResgate()

  #     @SetResgate =

  #     post("/SetResgate", body: @SetResgate.to_json)
  # end

  # def self.post_GetDoacao()

  #     @GetDoacao =

  #     post("/GetDoacao", body: @GetDoacao.to_json)
  # end

  # def self.post_SetDoacao()

  #     @SetDoacao =

  #     post("/SetDoacao", body: @SetDoacao.to_json)
  # end

  # def self.post_AtualizarPedidoPagSeguro()

  #     @AtualizarPedidoPagSeguro =

  #     post("/AtualizarPedidoPagSeguro", body: @AtualizarPedidoPagSeguro.to_json)
  # end
end
