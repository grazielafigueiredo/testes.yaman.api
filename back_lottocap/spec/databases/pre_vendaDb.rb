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
end