#frozen_string_literal: true


# context 'Criação de série/concurso MAX' do
#     #parametro mês da série/concurso
#     mes = 05
#     # TituloMatrizDB.new.relacionamento_serie_concurso(mes)
#     TituloMatrizDEV.new.relacionamento_serie_concurso(mes)
# end

context 'Verificar quantidade de títulos gerados do MAX, JA17, JA18' do
    # parametros idserie
    # verificar quantidade de vezes que a dezena foi gerada

    #MAX
    idSerie_max = Constant::IdSerieMaxPreVenda
    quantidade_matriz = TituloMatrizDB.new.select_count_matriz(idSerie_max)
    
    dezena_concurso = [
        '01', '02', '03', '04', '05', '06', '07', '08', '09', 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
        51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
        61, 62, 63, 64, 65, 66, 67, 68, 69, 70,
        71, 72, 73, 74, 75, 76, 77, 78, 79, 80
      ]
      quantidade_dezenas = []
      dezena_concurso.each do |data|
        # puts data
        quantidade_dezenas.push(TituloMatrizDB.new.quantidade_vezes_dezena_gerada(idSerie_max, data))
      end
    
    #   puts quantidade_dezenas
      it 'Verificar quantidade de títulos gerados e dezena repetida' do
        expect(quantidade_matriz).to match 82_160 # max
        quantidade_dezenas.each do |data|
          expect(data).to match 3081 # max
        end
      end

    #JA17
    idSerie_ja17 = Constant::IdSerieJa17
    quantidade_matriz_ja17 = TituloMatrizDB.new.select_count_matriz(idSerie_ja17)

    dezena_concurso = [
        '01', '02', '03', '04', '05', '06', '07', '08', '09', 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 23, 24, 25
      ]
      quantidade_dezenas = []
      dezena_concurso.each do |data|
        # puts data
        quantidade_dezenas.push(TituloMatrizDB.new.quantidade_vezes_dezena_gerada(idSerie_max, data))
      end
    
    #   puts quantidade_dezenas
      it 'Verificar quantidade de títulos gerados e dezena repetida' do
        expect(quantidade_matriz_ja17).to match 1081575 #JA17
        quantidade_dezenas.each do |data|
          expect(data).to match 3081 #JA17
        end
      end

    #JA18
    idSerie_ja18 = Constant::IdSerieJa18
    quantidade_matriz_ja18 = TituloMatrizDB.new.select_count_matriz(idSerie_ja18)

  dezena_concurso = [
    '01', '02', '03', '04', '05', '06', '07', '08', '09', 10,
    11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
    21, 22, 23, 24, 25
  ]
  quantidade_dezenas = []
  dezena_concurso.each do |data|
    # puts data
    quantidade_dezenas.push(TituloMatrizDB.new.quantidade_vezes_dezena_gerada(idSerie_max, data))
  end

#   puts quantidade_dezenas
  it 'Verificar quantidade de títulos gerados e dezena repetida' do
    expect(quantidade_matriz_ja18).to match 480700 #JA18
    quantidade_dezenas.each do |data|
      expect(data).to match 3081 #JA18
    end
  end
end

context 'Verificação de duplicidade do conjunto de dezenas' do
    idSerie = Constant::IdSerieMaxPreVenda

  titulos_duplicados_max = TituloMatrizDB.new.get_titulos_duplicados_by_idserie(idSerie)

  it {
    expect(titulos_duplicados_max).to match 0
  }
    idSerie_ja17 = Constant::IdSerieJa17

    titulos_duplicados_ja17 = TituloMatrizDB.new.get_titulos_duplicados_by_idserie(idSerie_ja17)

  it {
    expect(titulos_duplicados_ja17).to match 0
  }
  idSerie_ja18 = Constant::IdSerieJa18

  titulos_duplicados_ja18 = TituloMatrizDB.new.get_titulos_duplicados_by_idserie(idSerie_ja18)

  it {
    expect(titulos_duplicados_ja18).to match 0
  }
end


# context 'Criação de série/concurso Ja' do
#     #parametro para passar o mês da série/concurso

#     mes = 06
#     templateSerieId = 3 #17
#     # templateSerieId = 4 #18
#     # TituloMatrizDB.new.relacionamento_serie_concurso_ja(mes, idProduto_ja)
#     TituloMatrizDEV.new.relacionamento_serie_concurso_ja(mes, templateSerieId)
# end

context 'Criação de série/concurso Ja' do
    #parametro para passar o mês da série/concurso

    mes = 06
    idProduto_ja = 9  #17
    # idProduto_ja = 10  #18
    TituloMatrizDB.new.relacionamento_serie_concurso_ja(mes, idProduto_ja)
end
