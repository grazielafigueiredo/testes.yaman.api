# frozen_string_literal: true

require_relative 'db_base'
require 'timeout'

class BoletoDB < DbBase
  def update_final_date(time)
    @connection.execute("UPDATE Serie SET DataFinalVenda = '#{time}' where IdSerie = #{Constant::ID_SERIE_MAX_REGULAR};")
  end
end
