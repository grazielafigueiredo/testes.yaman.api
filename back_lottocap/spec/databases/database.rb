# frozen_string_literal: true

require_relative 'db_base'

require 'tiny_tds'
require 'timeout'

class Database < DbBase
  def update_TodosProdutosIndisponiveisVitrine(dataFinalVenda)
    @connection.execute("UPDATE Serie SET DataFinalVenda = '#{dataFinalVenda}';")
  end

  def update_reservarSerie(reservado)
    t = @connection.execute("UPDATE TituloMatriz SET reservado = #{reservado} where idSerie = #{Constant::IdSerieMaxRegular};")
    sleep 5
    puts t.do
  end

  def update_PremioResgate(valorBonus)
    @connection.execute("
            DECLARE @id AS INTEGER=#{Constant::UserID}
            DECLARE @insertsaldo AS INTEGER=#{valorBonus}

            BEGIN
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
                idUsuario = @id;

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
                @id,
                --idUsuario
                [dbo].fn_GETDATE(),
                @insertsaldo,
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
                @saldoTotal + @insertsaldo,
                --saldo
                @saldoPremio,
                --saldoPremio + @insertsaldo,
                @saldoCredito + @insertsaldo,
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
                SaldoCredito = @insertsaldo,
                SaldoPremio = @insertsaldo,
                SaldoTotal = @insertsaldo
            WHERE
                IdUsuario = @id;
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
