# frozen_string_literal: true

# context 'Criação de série/concurso' do
#         #parametro para passar o mês da série/concurso
#         Database.new.relacionamento_serie_concurso(04)
# end

# context 'Verificar quantidade de títulos gerados do MAX, JA17, JA18' do
#   quantidade_matriz = TituloMatrizDB.new.select_count_matriz(86)

#   # verificar quantidade de vezes que a dezena foi gerada
#   # parametros idserie, dezena
#   dezena_concurso = [
#     '01', '02', '03', '04', '05', '06', '07', '08', '09', 10,
#     11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
#     21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
#     31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
#     41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
#     51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
#     61, 62, 63, 64, 65, 66, 67, 68, 69, 70,
#     71, 72, 73, 74, 75, 76, 77, 78, 79, 80
#   ]
#   quantidade_dezenas = []
#   dezena_concurso.each do |data|
#     puts data
#     quantidade_dezenas.push(TituloMatrizDB.new.quantidade_vezes_dezena_gerada(86, data))
#   end

#   #   query = 'SELECT dezenas FROM TituloMatriz WHERE idSerie = 86'

#   #   result = []
#   #   result.each do |row|
#   #     query = "SELECT dezenas FROM TituloMatriz WHERE idSerie = 86 and dezenas = #{row['dezenas']}"
#   #     res = 1
#   #     expect(res.count).to match 1
#   #   end

#   puts quantidade_dezenas
#   it 'Verificar quantidade de títulos gerados e dezena repetida' do
#     expect(quantidade_matriz).to match 82_160 # max
#     quantidade_dezenas.each do |data|
#       expect(data).to match 3081 # max
#     end
#     # expect(quantidade_matriz).to match 480700 #ja18
#     # expect(quantidade_matriz).to match 1081575 #ja17
#   end
# end

context 'XXX' do
  id_serie = 86

  titulos_duplicados = TituloMatrizDB.new.get_titulos_duplicados_by_idserie(id_serie)

  it {
    expect(titulos_duplicados).to match 0
  }
end
