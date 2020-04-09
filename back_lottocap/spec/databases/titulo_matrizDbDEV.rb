
require_relative "db_base"

class TituloMatrizDEV < DbBase
  def select_count_matriz(idSerie)
    count_matriz = 
    @connection.execute("SELECT COUNT(*) FROM TituloMatriz WHERE idSerie = #{idSerie}")

    count_matriz.each do |row|
      return row['']
      # puts row
    end
  end

  def quantidade_vezes_dezena_gerada(idSerie, dezena)
    quantidade_vezes_dezena_gerada = 
    @connection.execute("SELECT COUNT(1) FROM TituloMatriz WHERE idSerie = #{idSerie} and dezenas like '%#{dezena}%'")

    quantidade_vezes_dezena_gerada.each do |row|
      return row['']
      # puts row
    end
  end

  def get_by_idserie(idSerie)
    query = "SELECT * FROM TituloMatriz WHERE idSerie = #{idSerie} and idTituloMatriz in (76193880,	76193881	,76193882	,76193883	,76193884	,76193885	)"
  
    result = @connection.execute(query)

    titulos = []
    result.each do |row|
      titulos.push(row)
    end

    return titulos
  end

  def get_by_idserie_dezenas(idSerie, dezena)
    query = "SELECT * FROM TituloMatriz WHERE idSerie = #{idSerie} and dezenas = '#{dezena}' and idTituloMatriz in (76193880,	76193881	,76193882	,76193883	,76193884	,76193885	)"

    result = @connection.execute(query)
    @connection.close()

    titulos = []
    result.each do |row|
      titulos.push(row)
    end

    return titulos
  end

  def get_titulos_duplicados_by_idserie(idSerie)
    query = "SELECT count(*), dezenas FROM TituloMatriz WHERE idSerie = #{idSerie} GROUP BY dezenas HAVING count(*) > 1"
    result = @connection.execute(query)

  
      result.each do |row|
        puts row
      end
  
      return result.do
    
  end

  def relacionamento_serie_concurso(month)
    today = Date.today
    today_add_10_days = today + 10

    datas_prevista_concurso = [
      02, 03, 04, 05, 06, 07,
      10, 11, 12, 13, 14, 16,
      17, 18, 19, 20, 21, 23,
      24, 25, 26, 27, 28, 29
    ]

    concursos_inseridos = []

    datas_prevista_concurso.each do |data|
      # dezena_nova = ((0..4).map { Random.new.rand(10..80) }).sort.join(' ')
      dezena_nova = ((0..4).map { Random.new.rand(1..80).to_s.rjust(2, "0") }).sort.join(' ')
      query = "INSERT INTO Concurso(
      idLoteria,
      nmConcurso,
      dtSorteio,
      resultado,
      aprovado,
      dtCriacao,
      idUsuarioCriacao
    )
      VALUES(
      4,
      #{Faker::Bank.account_number(digits: 4)},
      '2020-#{month}-#{data}',
      '#{dezena_nova}',
      0,
      '#{today}',
      1
    )"

      result_insert = @connection.execute(query)
      # puts 'Affected rows'
      results_concurso = @connection.execute('SELECT SCOPE_IDENTITY()')

      results_concurso.each do |concurso|
        concursos_inseridos.push(concurso[''].to_i)
      end
    end

    puts concursos_inseridos

    serie_inserida = []

    t = @connection.execute(
      create_serie =
        "INSERT Serie(
        Nome,
        DataInicialVigencia,
        DataFinalVigencia,
        DataInicialVenda,
        DataFinalVenda,
        Aprovado,
        PremioMaximoNoFimDaSerie,
        ProbabilidadeGanharAlgumPremioSerie,
        PercentualChanceDeGanhar,
        PremioMaximoPorDiaMax,
        PremiacaoTotal,
        QtdDeSorteios,
        Ativo,
        DataCriacao,
        idSerieEstado,
        IdUsuarioCriacao,
        PacoteTitulos,
        CorSerie,
        qtdMaxTitulosNaCompra,
        idSerieAplicap,
        TemplateSerieId
      )
        VALUES (
        'MAX - #{today}',
        '2020-#{month}-01',
        '2020-#{month}-30',
        '#{today}',
        '#{today_add_10_days}',
        0,
        250000.000,
        10,
        97.100,
        2500.000,
        240000.000,
        3,
        1,
        '#{today}',
        1,
        1,
        '1,3',
        '#000000',
        100,
        12,
        2
      )"
    )
    puts 'Affected rows'
    puts t.do

    result = @connection.execute('SELECT SCOPE_IDENTITY()')

    result.each do |row|
      serie_inserida.push(row[''].to_i)
    end
    puts serie_inserida

    concursos_inseridos.each do |concurso|
      quu = @connection.execute(
        "INSERT SerieConcurso(
        idSerie,
        idConcurso,
        dsConcurso,
        idAdminUsuario,
        dtCriacao,
        apurado
      )
        VALUES(
        #{serie_inserida[0]},
        #{concurso},
        'SEG',
        1,
        '#{today}',
        0
      )"
      )
      puts 'Affected rows'
      puts quu.do
    end

    valores = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB']
    

    contador = 0
    dia_da_semana = 0
    cont_data_concurso = 0
    
    concursos_inseridos.each do |concurso|
      # puts "#{concurso} - #{contador} - #{valores[dia_da_semana]}"
      
      query_ = "INSERT INTO TituloMatrizMultiplicador(
        idSerie,
        cdMultiplicador,
        valor,
        dtValor,
        dtCriacao,
        idConcurso
        )
        VALUES(
            #{serie_inserida[0]},
            'diadesorte',
            '#{valores[dia_da_semana]}',
            '2020-#{month}-#{datas_prevista_concurso[cont_data_concurso]}',
            '#{today}',
            #{concurso}
        )"

      res = @connection.execute( query_)
      puts 'TituloMatrizMultiplicador Affected rows'
      puts res.do

      cont_data_concurso += 1
      contador +=1
      if contador == 4
        contador = 0
        dia_da_semana += 1
      end

    end 
  end



  def relacionamento_serie_concurso_ja(month, templateSerieId)
    today = Date.today
    today_add_10_days = today + 10

    datas_prevista_concurso = [
      05
    ]

    concursos_inseridos = []

    datas_prevista_concurso.each do |data|
      dezena_nova = ["02 03 05 06 08 09 11 12 14 15 17 18 20 21 23"].sort.join(' ')
      query = "INSERT INTO Concurso(
      idLoteria,
      nmConcurso,
      dtSorteio,
      resultado,
      aprovado,
      dtCriacao,
      idUsuarioCriacao
    )
      VALUES(
      8,
      #{Faker::Bank.account_number(digits: 4)},
      '2020-#{month}-#{data}',
      '#{dezena_nova}',
      0,
      '#{today}',
      1
    )"

      result_insert = @connection.execute(query)
      # puts 'Affected rows'
      results_concurso = @connection.execute('SELECT SCOPE_IDENTITY()')

      results_concurso.each do |concurso|
        concursos_inseridos.push(concurso[''].to_i)
      end
    end

    puts concursos_inseridos

    serie_inserida = []

    t = @connection.execute(
      create_serie =
      "INSERT Serie(
        Nome,
        DataInicialVigencia,
        DataFinalVigencia,
        DataInicialVenda,
        DataFinalVenda,
        Aprovado,
        PremioMaximoNoFimDaSerie,
        ProbabilidadeGanharAlgumPremioSerie,
        PercentualChanceDeGanhar,
        PremioMaximoPorDiaMax,
        PremiacaoTotal,
        QtdDeSorteios,
        Ativo,
        DataCriacao,
        idSerieEstado,
        IdUsuarioCriacao,
        PacoteTitulos,
        CorSerie,
        qtdMaxTitulosNaCompra,
        idSerieAplicap,
        TemplateSerieId
      )
        VALUES (
        'JÁ - #{today}',
        '2020-#{month}-01',
        '2020-#{month}-30',
        '#{today}',
        '#{today_add_10_days}',
        1,
        250000.000,
        10,
        97.100,
        2500.000,
        240000.000,
        3,
        1,
        '#{today}',
        1,
        1,
        '1,3',
        '#000000',
        100,
        12,
        #{templateSerieId}
      )"
    )
    puts 'Affected rows'
    # puts t.do

    result = @connection.execute('SELECT SCOPE_IDENTITY()')

    result.each do |row|
      serie_inserida.push(row[''].to_i)
    end
    puts serie_inserida

    concursos_inseridos.each do |concurso|
      quu = @connection.execute(
        "INSERT SerieConcurso(
        idSerie,
        idConcurso,
        dsConcurso,
        idAdminUsuario,
        dtCriacao,
        apurado
      )
        VALUES(
        #{serie_inserida[0]},
        #{concurso},
        'SEG',
        1,
        '#{today}',
        0
      )"
      )
      puts 'Affected rows'
      puts quu.do
    end
  end
end