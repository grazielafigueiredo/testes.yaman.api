# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiTransferencia
  include HTTParty
  base_uri 'https://hmlapi.lottocap.com.br/api/Pagamento'
  headers 'Content-Type' => 'application/json'

  # ------------ Transferência Bancária (Bradesco)-----------------------

  def self.post_TransfSucessoBradesco(token, idCarrinho)
    headers['Authorization'] = token

    @TransfSucessoBradesco = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransf,
        "idCarrinho": idCarrinho,
        "transfAgencia": Faker::Bank.account_number(digits: 4),
        "transfConta": Faker::Bank.account_number(digits: 4),
        "transfContaDigito": Faker::Bank.account_number(digits: 1),
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/PagarCarrinho', body: @TransfSucessoBradesco.to_json)
  end

  def self.post_TransfContaInvalida(transfConta, token, idCarrinho)
    headers['Authorization'] = token

    @TransfContaInvalida = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransf,
        "idCarrinho": idCarrinho,
        "transfAgencia": Faker::Bank.account_number(digits: 4),
        "transfConta": transfConta,
        "transfContaDigito": Faker::Bank.account_number(digits: 1),
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/PagarCarrinho', body: @TransfContaInvalida.to_json)
  end

  def self.post_TransfDigitoInvalido(transfContaDigito, token, idCarrinho)
    headers['Authorization'] = token

    @TransfDigitoInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransf,
        "idCarrinho": idCarrinho,
        "transfAgencia": Faker::Bank.account_number(digits: 4),
        "transfConta": Faker::Bank.account_number(digits: 4),
        "transfContaDigito": transfContaDigito,
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/PagarCarrinho', body: @TransfDigitoInvalido.to_json)
  end

  def self.post_TransfNomeInvalido(nomeCompletoTitular, token, idCarrinho)
    headers['Authorization'] = token

    @TransfNomeInvalido = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransf,
        "idCarrinho": idCarrinho,
        "transfAgencia": Faker::Bank.account_number(digits: 4),
        "transfConta": Faker::Bank.account_number(digits: 4),
        "transfContaDigito": Faker::Bank.account_number(digits: 1),
        "nomeCompletoTitular": nomeCompletoTitular

      }
    }
    post('/PagarCarrinho', body: @TransfNomeInvalido.to_json)
  end

  def self.post_TransfAgenciaInvalida(transfAgencia, token, idCarrinho)
    headers['Authorization'] = token

    @TransfAgenciaInvalida = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransf,
        "idCarrinho": idCarrinho,
        "transfAgencia": transfAgencia,
        "transfConta": Faker::Bank.account_number(digits: 4),
        "transfContaDigito": Faker::Bank.account_number(digits: 1),
        "nomeCompletoTitular": Constant::NomeCompletoTitular

      }
    }
    post('/PagarCarrinho', body: @TransfAgenciaInvalida.to_json)
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
    post('/PagarCarrinho', body: @TransfSucessoItau.to_json)
    end

  # ------------ Transferência Bancária (Santander)-----------------------

  def self.post_TransfSucessoSantander(token, idCarrinho)
    headers['Authorization'] = token

    @TransfSucessoSantander = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransfSantander,
        "idCarrinho": idCarrinho,
        "cpf": Faker::CPF.numeric

      }
    }
    post('/PagarCarrinho', body: @TransfSucessoSantander.to_json)
  end

  def self.post_TransfSantanderInvalido(cpf, token, idCarrinho)
    headers['Authorization'] = token

    @TransfSucessoSantander = {
      "obj": {
        "idFormaPagamento": Constant::IdFormaPagamentoTransfSantander,
        "idCarrinho": idCarrinho,
        "cpf": cpf

      }
    }
    post('/PagarCarrinho', body: @TransfSucessoSantander.to_json)
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
