# frozen_string_literal: true

class PreVenda < DbBase
  def update_preVenda
    today = Date.today
    today_add_3_days = today + 4
    today_add_6_days = today + 6
    today_add_9_days = today + 9

    ta = @connection.execute(
      "UPDATE Serie SET DataInicialPreVenda= '#{today}',
            DataFinalPreVenda= '#{today_add_3_days}',
            DataInicialVenda= '#{today_add_6_days}',
            DataFinalVenda= '#{today_add_9_days}'
            WHERE IdSerie= #{Constant::IdSerieMaxPreVenda};"
    )
    puts ta.do

    puts today
    puts today_add_3_days
    puts today_add_6_days
    puts today_add_9_days
  end

  def update_reservar_titulo
    t = @connection.execute(
      "UPDATE TituloMatriz set reservado = 1
            where idSerie = #{Constant::IdSerieMaxPreVenda}
            and dezenas = '01 02 03'"
    )
    puts t.do
  end
end
