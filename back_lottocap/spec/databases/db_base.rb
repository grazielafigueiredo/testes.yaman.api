require 'tiny_tds'
require 'timeout'

class DbBase
  def initialize
    conn = {
      # username: 'graziela',
      # password: '4KoNxOHqNtTd6zZ',
      username: 'Lottocap',
      password: 'L0ttocap@sql2018',
      host: 'hmllottocap.database.windows.net',
      port: 1433,
      database: 'hmllottocaptests',
      azure: true
    }
    @connection = TinyTds::Client.new(conn)
  end
end