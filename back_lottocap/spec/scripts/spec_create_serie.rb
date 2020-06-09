# frozen_string_literal: true

# context 'Criação de série/concurso Ja' do
#     mes = 06
#     # templateSerieId = 3 #17
#     # templateSerieId = 4 #18
#     # TituloMatrizDEV.new.relacionamento_serie_concurso_ja(mes, templateSerieId)
# end
describe 'serie' do
  context '[MAX] - Criação de série/concurso' do
    mes = 9 # parametro mes da série/concurso
    TituloMatrizDB.new.relacionamento_serie_concurso(mes)
  end

  context '[JA 17] - Criação de série/concurso Ja' do
    mes = 9
    idProduto_ja = 9
    TituloMatrizDB.new.relacionamento_serie_concurso_ja(mes, idProduto_ja)
  end

  context '[JA 18] - Criação de série/concurso Ja' do
    mes = 9
    idProduto_ja = 10
    TituloMatrizDB.new.relacionamento_serie_concurso_ja(mes, idProduto_ja)
  end
end
