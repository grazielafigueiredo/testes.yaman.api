# frozen_string_literal: true

require 'dotenv'
Dotenv.load

class Constant
  Url = ENV['URL']
  URLPROD = ENV['URLPROD']

  IdSerieMaxRegular = ENV['ID_SERIE_MAX_REGULAR']
  IdSerieMaxPreVenda = ENV['ID_SERIE_MAX_PRE_VENDA']
  IdSerieJa17 = ENV['ID_SERIE_JA_18']
  IdSerieJa18 = ENV['ID_SERIE_JA_17']

  IdProduto = ENV['ID_PRODUTO_MAX']

  User1 = { "usuario": ENV['USER_1_NAME'], "senha": ENV['USER_1_PASSWORD'] }.freeze
  UserID = ENV['USER_1_ID']
  User2 = { "usuario": ENV['USER_2_NAME'], "senha": ENV['USER_2_PASSWORD'] }.freeze
  # UserID2 = USER_2_ID

  ValidadeAnoCartao = ENV['VALIDADE_ANO_CARTAO']
end
