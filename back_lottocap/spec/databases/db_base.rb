require 'tiny_tds'
require 'timeout'

class DbBase
  def initialize
    conn = {
      # username: 'graziela',
      # password: '4KoNxOHqNtTd6zZ',
      username: 'Lottocap',
      password: 'L0ttocap19!12@',
      host: 'hmllottocap.database.windows.net',
      port: 1433,
      # database: 'hmllottocaptests',
      database: 'hmllottocap',
      azure: true,
      timeout: 55
    }
    @connection = TinyTds::Client.new(conn)
  end
  # def initialize
  #   conn = {
  #     username: 'sa',
  #     password: 'L0ttocap19!',
  #     host: 'localhost',
  #     port: 1433,
  #     database: 'master'
  #   }
  #   @connection = TinyTds::Client.new(conn)
  # end
end