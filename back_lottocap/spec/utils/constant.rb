# frozen_string_literal: true

require 'time'
require 'singleton'

class Constant
#   Url = 'https://lottocap-hml-server01-api.azurewebsites.net/api'
  # Url = "http://localhost:8080/api"

#   Url = "https://prodlottocapapi-staging.azurewebsites.net/api"
  Url = "https://api-dev1.lottocap.com.br/api"


    #####QA 1########
    # IdSerieMaxRegular = 215
    # IdSerieMaxRegular = 32
    # IdSerieMaxPreVenda = 108
    # IdSerieJa17 = 88
    # IdSerieJa18 = 89

    # IdProdutoJa18 = 10
    # IdProduto = 1
    # IdProdutoJa = 9

#     User1 = { "usuario": 'user22@gmail.com', "senha": '1234' }.freeze
#     UserID = 3661
    
#     User2 = { "usuario": 'user666@gmail.com', "senha": '1234' }.freeze
#     # UserID = 3705

#   # Cartao de Credito

#     ValidadeAnoCartao = '27'

    ####DEV 1######
    IdSerieMaxRegular = 109
    IdSerieMaxPreVenda = 108
    IdSerieJa17 = 117
    IdSerieJa18 = 111
    
    
    IdProdutoJa18 = 10
    IdProduto = 1
    IdProdutoJa = 9

    User1 = { "usuario": 'user22@gmail.com', "senha": '1234' }.freeze
    UserID = 3705
    
    User2 = { "usuario": 'user666@gmail.com', "senha": '1234' }.freeze
    # UserID = 3705

  # Cartao de Credito

    ValidadeAnoCartao = '27'
end
