# frozen_string_literal: true

require 'time'
require 'singleton'

class Constant
  Url = 'https://lottocap-hml-server01-api.azurewebsites.net/api'
  # Url = "http://localhost:8080/api"

#   Url = "https://lottocap-hml-server01-api-staging.azurewebsites.net/api"

    IdSerieMaxRegular = 215
    IdSerieMaxPreVenda = 218
    IdSerieJa17 = 88
    IdSerieJa18 = 89
    
    
    IdProdutoJa18 = 10
    IdProduto = 1
    IdProdutoJa = 9

    User1 = { "usuario": 'user22@gmail.com', "senha": '1234' }.freeze
    UserID = 3661
    User2 = { "usuario": 'user666@gmail.com', "senha": '1234' }.freeze
    # UserID = 3705

  # Cartao de Credito

    ValidadeAnoCartao = '27'
end
