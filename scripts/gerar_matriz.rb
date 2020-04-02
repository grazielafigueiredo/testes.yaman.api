def gerar_body
    signos = %w(01 02 03 04 05 06 07 08 09 10 11 12)
    signosArray =  signos.permutation(3).to_a
    contador = 1

    arquivo = ""

    empresa = 'PARATY TECNOLOG'
    cnpj = '300011230001080'
    qtd_proposta = sprintf(("%.8d"), signosArray.count)
    prefixo = 'SIGNO'
    serie = '00014'
    mes_ano = '032020'

    header = "H#{empresa}#{cnpj}#{qtd_proposta}#{prefixo}#{serie}#{mes_ano}"

    filled_header = header.ljust(100, ' ')
    
    arquivo += "#{filled_header}"

    for signo in signosArray
      sequencial =  sprintf(("%.8d"), contador)
      
      linha = "#{signo.join()}"
      filled_body = linha.ljust(100, ' ')

      arquivo += "\n#{filled_body}"
      contador +=1
    end

    total_signos = sprintf(("%.9d"), signosArray.count + 2)

    footer = "T#{total_signos}"
    filled_footer = footer.ljust(100, ' ')
    
    arquivo += "\n#{filled_footer}"

    nome_arquivo = "signo.matriz.#{mes_ano}.txt"
    File.new(nome_arquivo, "w").puts(arquivo)
  end

gerar_body