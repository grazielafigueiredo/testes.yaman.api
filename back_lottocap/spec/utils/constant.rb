require "time"
require "singleton"

class Constant
    IdSerie = 86
    IdProduto = 1
    IdCarrinho = 10851
    TimeMsg = Time.now.strftime('%d/%m/%Y')
    Authorization = "10b37fe3-504e-446a-aaae-0573d9c98d9a"

    User1 = {"usuario": "user1@gmail.com", "senha": "1234"}
    # Cartao de Credito

    IdFormaPagamento = 5
    NomeCompletoTitular = "CARLOS"
    NumeroCartao = "5521884306233764"
    ValidadeMesCartao = "11"
    ValidadeAnoCartao = "27"
    CartaoCVV = "123"

    # Boleto
    IdFormaPagamentoBoleto = 10
    
    # Credito Lottocap
    IdFormaPagamentoCreditoLottocap = 11

    # Transferencia

    TransfAgencia = "1111"
    TransfConta = "1234567"
    TransfContaDigito = "1"
    TransfAgenciaDigito = "1"

    IdFormaPagamentoTransf =  6  #Bradesco

    IdFormaPagamentoTransfItau = 7  #Itau

    # {
    #     "obj": {
    #         "idFormaPagamento": 7,
    #         "idCarrinho": 10846,
    #         "transfAgencia": "3456",
    #         "transfAgenciaDigito": "",
    #         "transfConta": "34567",
    #         "transfContaDigito": "3",
    #         "nomeCompletoTitular": "rtyui",
    #         "flCompraDeCredito": false,
    #         "valorCreditos": 0,
    #         "dadosComplementaresUsuario": null,
    #         "utmCampanhas": "{\"conversao_medium\":\"direto\"}",
    #         "sessionIdAmplitude": 1574785719863,
    #         "deviceIdAmplitude": "d934a7f5-cc43-437d-bc13-f5f30d8e43c7R"
    #     },
    #     "atualPagina": 1,
    #     "tamanhoPagina": 9999
    # }

    IdFormaPagamentoTransfSantander = 8 #Santander
     Cpf = "000.000.096-52"

    # {
    #     "obj": {
    #         "idFormaPagamento": 8,
    #         "idCarrinho": 10847,
    #         "cpf": "000.000.096-52",
    #         "flCompraDeCredito": false,
    #         "valorCreditos": 0,
    #         "dadosComplementaresUsuario": null,
    #         "utmCampanhas": "{\"conversao_medium\":\"direto\"}",
    #         "sessionIdAmplitude": 1574791074147,
    #         "deviceIdAmplitude": "d934a7f5-cc43-437d-bc13-f5f30d8e43c7R"
    #     },
    #     "atualPagina": 1,
    #     "tamanhoPagina": 9999
    # }

    IdFormaPagamentoTransfBrasil = 9

    # {
    #     "obj": {
    #         "idFormaPagamento": 9,
    #         "idCarrinho": 10848,
    #         "transfAgencia": "5678",
    #         "transfAgenciaDigito": "6",
    #         "transfConta": "1234567891",
    #         "transfContaDigito": "2",
    #         "nomeCompletoTitular": "fghj",
    #         "flCompraDeCredito": false,
    #         "valorCreditos": 0,
    #         "dadosComplementaresUsuario": null,
    #         "utmCampanhas": "{\"conversao_medium\":\"direto\"}",
    #         "sessionIdAmplitude": 1574791074147,
    #         "deviceIdAmplitude": "d934a7f5-cc43-437d-bc13-f5f30d8e43c7R"
    #     },
    #     "atualPagina": 1,
    #     "tamanhoPagina": 9999
    # }

    # payload de dados já salvos no banco

    # {
    #     "obj": {
    #         "idFormaPagamento": 9,
    #         "idCarrinho": 10850,
    #         "idUsuarioContaCorrente": 1686,
    #         "flCompraDeCredito": false,
    #         "valorCreditos": 0,
    #         "dadosComplementaresUsuario": null,
    #         "utmCampanhas": "{\"conversao_medium\":\"direto\"}",
    #         "sessionIdAmplitude": 1574791074147,
    #         "deviceIdAmplitude": "d934a7f5-cc43-437d-bc13-f5f30d8e43c7R"
    #     },
    #     "atualPagina": 1,
    #     "tamanhoPagina": 9999
    # }
end

