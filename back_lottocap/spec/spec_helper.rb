# frozen_string_literal: true

# require 'blabla'
require 'cpf_faker'
require 'date'
require 'faker'
require 'factory_bot'
require 'httparty'
require 'json'
require 'rspec'
require 'tiny_tds'
require 'timeout'


require_relative 'databases/boleto_DB'
require_relative 'databases/cart_DB'
require_relative 'databases/credit_lottocap_DB'
require_relative 'databases/create_user_DB'
require_relative 'databases/database'
require_relative 'databases/money_rescue_DB'
require_relative 'databases/pre_venda_DB'
require_relative 'databases/transfer_DB'
require_relative 'databases/titulo_DB'
require_relative 'databases/titulo_matrizDb'
require_relative 'databases/titulo_matrizDbDEV'

require_relative 'factories/boleto_factory'
require_relative 'factories/cart_factory'
require_relative 'factories/credit_card_factory'
require_relative 'factories/credit_lottocap_factory'
require_relative 'factories/titulo_factory'
require_relative 'factories/money_rescue_factory'
require_relative 'factories/pre_venda_factory'
require_relative 'factories/rng_factory'
require_relative 'factories/transfer_factory'
require_relative 'factories/user_factory'

require_relative 'services/aplicap'
require_relative 'services/boleto_service'
require_relative 'services/cart_service'
require_relative 'services/create_user_service'
require_relative 'services/credit_card_service'
require_relative 'services/credit_lottocap_service'
require_relative 'services/landing_service'
require_relative 'services/money_rescue_service'
require_relative 'services/pre_venda_service'
require_relative 'services/producao'
require_relative 'services/ranking'
require_relative 'services/rng_service'
require_relative 'services/transfer_service'
require_relative 'services/titulo_service'
require_relative 'services/user'


RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include FactoryBot::Syntax::Methods
  
  config.before :each do
    @token = ApiUser.GetToken
    @login = ApiUser.Login(@token, build(:login).to_hash)
    @idUsuario = @login.parsed_response['obj'][0]['idUsuario']

  end

  config.before :all do
    CartDB.new.update_dataFinalVendaVigente('2020-12-25')
  end


  config.after :each do
    ApiUser.get_logout(@token)
  end

  config.after :all do
    CartDB.new.update_dataFinalVendaVigente('2020-12-25')
  end
end


RSpec.configure do |config|
  config.example_status_persistence_file_path = 'some_file.txt'
end