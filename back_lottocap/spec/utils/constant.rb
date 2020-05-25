# frozen_string_literal: true

require 'dotenv'
Dotenv.load

class Constant
  Url = ENV['URL']

  IdSerieMaxRegular = ENV['ID_SERIE_MAX_REGULAR']
  IdSerieMaxPreVenda = ENV['ID_SERIE_MAX_PRE_VENDA']
  IdSerieJa17 = ENV['ID_SERIE_JA_18']
  IdSerieJa18 = ENV['ID_SERIE_JA_17']

  IdProdutoJa18 = ENV['ID_PRODUTO_JA_18']
  IdProduto = ENV['ID_PRODUTO_MAX']
  IdProdutoJa = ENV['ID_PRODUTO_JA_17']

  User1 = { "usuario": ENV['USER_1_NAME'], "senha": ENV['USER_1_PASSWORD'] }.freeze
  UserID = ENV['USER_1_ID']
  # print(UserID)
  User2 = { "usuario": ENV['USER_2_NAME'], "senha": ENV['USER_2_PASSWORD'] }.freeze
  # UserID2 = USER_2_ID

  # Cartao de Credito

  ValidadeAnoCartao = ENV['VALIDADE_ANO_CARTAO']
end
