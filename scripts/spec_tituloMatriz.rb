#frozen_string_literal: true


context 'Criação de série/concurso MAX' do
    #parametro mês da série/concurso
    mes = 06
    TituloMatrizDB.new.relacionamento_serie_concurso(mes)
end


# context 'Criação de série/concurso Ja' do
#     #parametro para passar o mês da série/concurso

#     mes = 04
#     idProduto_ja = 9  #17
#     # idProduto_ja = 10  #18
#     TituloMatrizDB.new.relacionamento_serie_concurso_ja(mes, idProduto_ja)
# end
