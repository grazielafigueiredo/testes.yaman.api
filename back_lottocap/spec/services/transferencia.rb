# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiTransferencia
  include HTTParty
  base_uri 'https://hmlapi.lottocap.com.br/api'
  headers 'Content-Type' => 'application/json'

  # ------------ Transferência Bancária (Bradesco)-----------------------

  def self.post_TransfBradesco(token, idCarrinho, transfAgencia, transfConta, transfContaDigito, nomeCompletoTitular)
    headers['Authorization'] = token

    @TransfBradesco = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransf,
        "idCarrinho": idCarrinho,
        "transfAgencia": transfAgencia,
        "transfConta": transfConta,
        "transfContaDigito": transfContaDigito,
        "nomeCompletoTitular": nomeCompletoTitular

      }
    }
    post('/Pagamento/PagarCarrinho', body: @TransfBradesco.to_json)
  end

  # ------------ Transferência Bancária (Itau)-----------------------

  def self.post_TransfSucessoItau(token, idCarrinho)
    headers['Authorization'] = token

    @TransfSucessoItau = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransfItau,
        "idCarrinho": idCarrinho,
        "transfAgencia": Faker::Bank.account_number(digits: 4),
        "transfAgenciaDigito": '',
        "transfConta": Faker::Bank.account_number(digits: 4),
        "transfContaDigito": Faker::Bank.account_number(digits: 1),
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/Pagamento/PagarCarrinho', body: @TransfSucessoItau.to_json)
    end

  # ------------ Transferência Bancária (Santander)-----------------------

  def self.post_TransfSantander(token, idCarrinho, cpf)
    headers['Authorization'] = token

    @TransfSantander = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransfSantander,
        "idCarrinho": idCarrinho,
        "cpf": cpf
      }
    }
    post('/Pagamento/PagarCarrinho', body: @TransfSantander.to_json)
  end

  # ------------ Transferência Bancária (Brasil)-----------------------

  def self.post_TransfSucessoBrasil(token, idCarrinho)
    headers['Authorization'] = token

    @TransfSucessoBrasil = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransfBrasil,
        "idCarrinho": idCarrinho,
        "transfAgencia": Faker::Bank.account_number(digits: 4),
        "transfAgenciaDigito": Faker::Bank.account_number(digits: 1),
        "transfConta": Faker::Bank.account_number(digits: 10),
        "transfContaDigito": Faker::Bank.account_number(digits: 1),
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/Pagamento/PagarCarrinho', body: @TransfSucessoBrasil.to_json)
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
