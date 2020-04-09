require 'tiny_tds'
require 'timeout'
require 'dotenv'

class DbBase
  def initialize
    azure_bool = ENV['DATABASE_AZURE'].to_s.downcase == 'true'
    conn = {
      username: ENV['DATABASE_USERNAME'],
      password: ENV['DATABASE_PASSWORD'],
      host: ENV['DATABASE_HOST'],
      port: ENV['DATABASE_PORT'],
      database: ENV['DATABASE_DATABASE'],
      azure: azure_bool,
      timeout: ENV['DATABASE_TIMEOUT']
    }
    @connection = TinyTds::Client.new(conn)
  end
end