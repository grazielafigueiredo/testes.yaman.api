
require_relative "db_base"

class TituloMatrizDB < DbBase
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


end