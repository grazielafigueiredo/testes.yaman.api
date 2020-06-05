# frozen_string_literal: true

require 'dotenv'
Dotenv.load

class Constant
  URI_HOMOLOG = ENV['URI_HOMOLOG']
  URIPROD = ENV['URIPROD']

  ID_SERIE_MAX_REGULAR = ENV['ID_SERIE_MAX_REGULAR']
  ID_SERIE_MAX_PRE_VENDA = ENV['ID_SERIE_MAX_PRE_VENDA']
  ID_SERIE_JA_17 = ENV['ID_SERIE_JA_17']
  ID_SERIE_JA_18 = ENV['ID_SERIE_JA_18']

  IdProduto = ENV['ID_PRODUTO_MAX']

  USER = { "usuario": ENV['USER_1_NAME'], "senha": ENV['USER_1_PASSWORD'] }.freeze

  ValidadeAnoCartao = ENV['VALIDADE_ANO_CARTAO']
end
