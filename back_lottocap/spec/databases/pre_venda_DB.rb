# frozen_string_literal: true

class Pre_vendaDB < DbBase
  def update_pre_venda
    today = Date.today
    today_add_3_days = today + 4
    today_add_6_days = today + 6
    today_add_9_days = today + 10

    @connection.execute(
      "UPDATE Serie SET DataInicialPreVenda= '#{today}',
            DataFinalPreVenda= '#{today_add_3_days}',
            DataInicialVenda= '#{today_add_6_days}',
            DataFinalVenda= '#{today_add_9_days}'
            WHERE IdSerie= #{Constant::ID_SERIE_MAX_PRE_VENDA}"
    )
    # puts today
    # puts today_add_3_days
    # puts today_add_6_days
    # puts today_add_9_days
  end

  def update_reservar_titulo
    @connection.execute(
      "UPDATE TituloMatriz set reservado = 1
            where idSerie = #{Constant::ID_SERIE_MAX_PRE_VENDA}
            and dezenas = '01 02 03'"
    )
  end
  def update_reservar_group_dezenas(group_dezenas)
    @connection.execute(
      "UPDATE TituloMatriz set reservado = 1
            where idSerie = #{Constant::ID_SERIE_MAX_PRE_VENDA}
            and dezenas = '#{group_dezenas}'"
    )
  end
end
