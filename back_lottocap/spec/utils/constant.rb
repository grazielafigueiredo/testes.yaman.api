# frozen_string_literal: true

require 'dotenv'
Dotenv.load

class Constant
#   Url = 'https://lottocap-hml-server01-api.azurewebsites.net/api'
  # Url = "http://localhost:8080/api"

#   Url = "https://prodlottocapapi-staging.azurewebsites.net/api"
  # Url = "https://api-dev1.lottocap.com.br/api"

    Url = ENV['URL'] 

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

    IdSerieMaxRegular = ENV['ID_SERIE_MAX_REGULAR']
    IdSerieMaxPreVenda = ENV['ID_SERIE_MAX_PRE_VENDA']
    IdSerieJa17 = ENV['ID_SERIE_JA_18']
    IdSerieJa18 = ENV['ID_SERIE_JA_17']
    
    
    IdProdutoJa18 = ENV['ID_PRODUTO_JA_18']
    IdProduto = ENV['ID_PRODUTO_MAX']
    IdProdutoJa = ENV['ID_PRODUTO_JA_17']

    User1 = { "usuario": ENV['USER_1_NAME'], "senha": ENV['USER_1_PASSWORD'] }.freeze
    UserID = ENV['USER_1_ID']
    print(UserID)
    User2 = { "usuario": ENV['USER_2_NAME'], "senha": ENV['USER_2_PASSWORD'] }.freeze
    # UserID2 = USER_2_ID

  # Cartao de Credito

    ValidadeAnoCartao = ENV['VALIDADE_ANO_CARTAO']
end
