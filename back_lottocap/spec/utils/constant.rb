require "time"
require "singleton"

class Constant

    Url = "https://hmlapi.lottocap.com.br/api"
    IdSerie = 86
    IdSerie87 = 87
    IdProduto = 1
    IdCarrinho = 10851
    IdTitulo = 62290
    IdSerieJa = 88
    IdProdutoJa = 9
    
    TimeMsg = Time.now.strftime('%d/%m/%Y')
    Authorization = "70b90407-f1f6-4868-bad2-dda283b09bf9"
    Produto = "LottoCap Max - Max Série Nova (id 86)"

    User1 = {"usuario": "user22@gmail.com", "senha": "1234"}
    UserID = 3661
    # User1 = {"usuario": "user22@gmail.com", "senha": "1234"}
    # UserID = 3705
    
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
    IdFormaPagamentoTransfSantander = 8 #Santander
     Cpf = "000.000.096-52"
    IdFormaPagamentoTransfBrasil = 9


    #Alterar Dados

    Apelido = "grazi"
    NomeCompleto = "grazi a"
    Email = "user22@gmail.com"
    CpfDados = "44302702010"
    TelefoneDDD = "11"
    TelefoneNumero = "23456789"
    CEP = "06160000"
    DataNascimento = "1995-01-01T00:00:00-02:00"
    EnderecoLogradouro = "Avenida Benedito Alves Turíbio"
    EnderecoNumero = "7777"
    EnderecoComplemento = "até 501/502"
    EnderecoBairro = "Padroeira"
    EnderecoCidade = "Osasco"
    EnderecoEstado = "SP"
end

