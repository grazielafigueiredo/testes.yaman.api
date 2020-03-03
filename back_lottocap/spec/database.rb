# frozen_string_literal: true

require 'tiny_tds'
require 'timeout'

class Database
  def initialize
    conn = {
      # username: 'graziela',
      # password: '4KoNxOHqNtTd6zZ',
      username: 'Lottocap',
      password: 'L0ttocap19!12@',
      host: 'hmllottocap.database.windows.net',
      port: 1433,
      database: 'hmllottocaptests',
      azure: true
    }
    @connection = TinyTds::Client.new(conn)
  end

  # def initialize
  #     conn = {
  #         username: 'prdlottocap_Copy',
  #         password: 'Lottocap',
  #         host: 'hmllottocap.database.windows.net',
  #         port: 1433,
  #         database: 'L0ttocap@sql2018',
  #         azure:true
  #     }
  #     @connection =  TinyTds::Client.new(conn)
  # end

  def update_DataFinalVendaVigente(dataFinalVenda)
    t = @connection.execute("UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}' where IdSerie= #{Constant::IdSerie};")
    puts t.do
  end

  def update_TodosProdutosIndisponiveisVitrine(dataFinalVenda)
    @connection.execute("UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}';")
  end

  def update_BloquearPagamento
    time = Time.now.strftime('%F')
    @connection.execute("UPDATE Serie SET DataFinalVenda = '#{time}' where idSerie = #{Constant::IdSerie};")
  end

  def update_reservarSerie(reservado)
    t = @connection.execute("UPDATE TituloMatriz SET reservado = #{reservado} where idSerie = #{Constant::IdSerie};")
    sleep 5
    puts t.do
  end

  def update_MaxNaVitrine(dataFinalVenda)
    @connection.execute("UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}' where IdProduto = 1;")
    # sleep 2
  end

  def update_MaxReservados(reservado) ##### reservar todos os titulos da série MAX
    res = @connection.execute("UPDATE TituloMatriz
                                    SET reservado = #{reservado}
                                    FROM TituloMatriz as T
                                    INNER JOIN Serie as S ON T.idSerie = S.IdSerie
                                    WHERE IdProduto = 1")
    sleep 55
    # Timeout::timeout 10
    puts 'Affected rows'
    puts res.do
  end

  def update_CreditoLottocap(saldoCredito)
    @connection.execute("BEGIN
            DECLARE @saldoTotal decimal(18, 3);
            DECLARE @saldoPremio decimal(18, 3);
            DECLARE @saldoCredito decimal(18, 3);
            DECLARE @saldoCapitalizacao decimal(18, 3);

            SELECT
                @saldoTotal = saldoTotal,
                @saldoPremio = saldoPremio,
                @saldoCredito = saldoCredito,
                @saldoCapitalizacao = saldoCapitalizacao
            FROM USUARIO
            WHERE
                idUsuario = #{Constant::UserID};

            INSERT INTO [dbo].[UsuarioCredito] (
                [idUsuario],
                [dtCredito],
                [valor],
                [flPremio],
                [flCredito],
                [flDebito],
                [flResgate],
                [flEstorno],
                [idStatus],
                [idTituloMatrizApuracaoConcurso],
                [idPagamento],
                [idTituloMatriz],
                [idConcurso],
                [idResgate],
                [idPromocao],
                [idPromocaoUsuario],
                [idPromocaoUsuarioItem],
                [saldo],
                [saldoPremio],
                [saldoCredito],
                [saldoCapitalizacao],
                [utilizadoPremio],
                [utilizadoCredito],
                [utilizadoCapitalizacao],
                [dsTipoCredito],
                [dsTipoCreditoWeb],
                [nmConcurso],
                [dtConcurso],
                [nmTipoPremio],
                [nmProdutoSerie]
            )
            VALUES
            (
                #{Constant::UserID},
                --idUsuario
                [dbo].fn_GETDATE(),
                #{saldoCredito},
                --vlTransação
                0,
                1,
                --flCrédito
                0,
                0,
                0,
                1,
                --Status
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                0,
                0,
                0,
                @saldoTotal + #{saldoCredito},
                --saldo
                @saldoPremio,
                --saldoPremio
                @saldoCredito + #{saldoCredito},
                --saldoCrédito
                @saldoCapitalizacao,
                --saldoCapitalização
                0,
                0,
                0,
                'Bônus',
                'Bônus',
                NULL,
                NULL,
                NULL,
                NULL
            );

            UPDATE Usuario
            SET
                SaldoCredito = #{saldoCredito},
                SaldoTotal = #{saldoCredito}
            WHERE
                IdUsuario = #{Constant::UserID};
        END;")
    # end        puts rs
  end

  def update_PremioResgate(valorBonus)
    @connection.execute("BEGIN
            DECLARE @saldoTotal decimal(18, 3);
            DECLARE @saldoPremio decimal(18, 3);
            DECLARE @saldoCredito decimal(18, 3);
            DECLARE @saldoCapitalizacao decimal(18, 3);

            SELECT
                @saldoTotal = saldoTotal,
                @saldoPremio = saldoPremio,
                @saldoCredito = saldoCredito,
                @saldoCapitalizacao = saldoCapitalizacao
            FROM USUARIO
            WHERE
                idUsuario = #{Constant::UserID};

            INSERT INTO [dbo].[UsuarioCredito] (
                [idUsuario],
                [dtCredito],
                [valor],
                [flPremio],
                [flCredito],
                [flDebito],
                [flResgate],
                [flEstorno],
                [idStatus],
                [idTituloMatrizApuracaoConcurso],
                [idPagamento],
                [idTituloMatriz],
                [idConcurso],
                [idResgate],
                [idPromocao],
                [idPromocaoUsuario],
                [idPromocaoUsuarioItem],
                [saldo],
                [saldoPremio],
                [saldoCredito],
                [saldoCapitalizacao],
                [utilizadoPremio],
                [utilizadoCredito],
                [utilizadoCapitalizacao],
                [dsTipoCredito],
                [dsTipoCreditoWeb],
                [nmConcurso],
                [dtConcurso],
                [nmTipoPremio],
                [nmProdutoSerie]
            )
            VALUES
            (
                #{Constant::UserID},
                --idUsuario
                [dbo].fn_GETDATE(),
                #{valorBonus},
                --vlTransação
                0,
                1,
                --flCrédito
                0,
                0,
                0,
                1,
                --Status
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                0,
                0,
                0,
                @saldoTotal + #{valorBonus},
                --saldo
                @saldoPremio,
                --saldoPremio + #{valorBonus},
                @saldoCredito + #{valorBonus},
                --saldoCrédito
                @saldoCapitalizacao,
                --saldoCapitalização
                0,
                0,
                0,
                'Bônus',
                'Bônus',
                NULL,
                NULL,
                NULL,
                NULL
            );

            UPDATE Usuario
            SET
                SaldoCredito = #{valorBonus},
                SaldoPremio = #{valorBonus},
                SaldoTotal = #{valorBonus}
            WHERE
                IdUsuario = #{Constant::UserID};
        END;")
  end

  def update_deletePremioResgate
    @connection.execute("UPDATE Usuario SET  SaldoPremio = 0.000  where IdUsuario = #{Constant::UserID};")
  end

  def select_GetQtdTitulosUsuario
    t = @connection.execute("SELECT COUNT(tm.idTituloMatriz) AS TOTAL
        FROM dbo.TituloMatriz tm
             INNER JOIN dbo.Titulo t ON t.IdTituloMatriz = tm.IdTituloMatriz
             INNER JOIN dbo.SERIE s ON tm.idSerie = s.IdSerie
        WHERE tm.idUsuarioCliente = #{Constant::UserID}
              AND t.DataVisualizacao IS NULL
              AND S.Aprovado = 1
              AND S.Ativo = 1
              AND S.idSerieEstado = 4;")

    t
  end

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

  def select_count_generated_titulos
    t = @connection.execute(
      "SELECT COUNT (*) FROM TituloMatriz as T
        INNER JOIN Serie as S ON T.idSerie = S.IdSerie
        WHERE IdProduto = 1
        and T.idSerie = 86"
    )
    puts 'Affected rows'
    puts t.do
  end

  def insert_create_concursos
    @today = Date.today
    monday = Time.now.strftime('%m')

    datas_prevista_concurso = [
      # 01,
      20
    ]

    @concursos_inseridos = []

    datas_prevista_concurso.each do |data|
      dezena_nova = ((0..4).map { Random.new.rand(10..80) }).sort.join(' ')

      query = "INSERT INTO Concurso(idLoteria, nmConcurso, dtSorteio, resultado, aprovado, dtCriacao, idUsuarioCriacao)
      VALUES(4, #{Faker::Bank.account_number(digits: 4)}, '2020-04-#{data}', '#{dezena_nova}', 1, '#{@today}', 1)"

      result_insert = @connection.execute(query)
      # puts 'Affected rows'
      result = @connection.execute('SELECT SCOPE_IDENTITY()')

      result.each do |row|
        @concursos_inseridos.push(row[''].to_i)
      end

      # result.each do |row|
      #   puts row['idConcurso']
      #   puts row['idLoteria']
      #   puts row['dtSorteio']
      # end
    end

    puts @concursos_inseridos
  end

  def insert_create_serie
    today = Date.today

    @serie_inserida = []

    t = @connection.execute(
      create_serie = "INSERT Serie(IdProduto, Nome, Preco, DataInicialVigencia, DataFinalVigencia, DataInicialVenda, DataFinalVenda, Aprovado, Ativo, DataCriacao, idSerieEstado,IdUsuarioCriacao, PacoteTitulos, CorSerie)
        VALUES (1, 'MAX - #{today}', 50.000, '2020-04-01', '2020-04-30', '2020-04-30', '2020-04-30', 1, 1, '#{today}', 1, 1, '1,3', '#000000')"
    )
    puts 'Affected rows'
    puts t.do

    # result_insert = @connection.execute(create_serie)
    # puts 'Affected rows'
    result = @connection.execute('SELECT SCOPE_IDENTITY()')

    result.each do |row|
      @serie_inserida.push(row[''].to_i)
    end
    puts @serie_inserida
  end

  def relacionamento_serie_concurso(month)
    today = Date.today
    today_add_10_days = today + 10

    datas_prevista_concurso = [
      02,
      03,
      04,
      05,
      06,
      07,
      10,
      11,
      12,
      13,
      14,
      16,
      17,
      18,
      19,
      20,
      21,
      23,
      24,
      25,
      26,
      27,
      28,
      29
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
      1,
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
        IdProduto,
        Nome,
        Preco,
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
        porcDoacao,
        qtdMaxTitulosNaCompra,
        idSerieAplicap,
        PercentualComissao
      )
        VALUES (
        1,
        'MAX - #{today}',
        50.000,
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
        2.00,
        100,
        12,
        20.00
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
  end

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
end


