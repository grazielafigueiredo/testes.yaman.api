# frozen_string_literal: true

context 'Criação de série/concurso Ja' do
    #parametro para passar o mês da série/concurso

    mes = 06
    # templateSerieId = 3 #17
    idProduto_ja = 9 #17
    # templateSerieId = 4 #18
    TituloMatrizDB.new.relacionamento_serie_concurso_ja(mes, idProduto_ja)
    # TituloMatrizDEV.new.relacionamento_serie_concurso_ja(mes, templateSerieId)
end