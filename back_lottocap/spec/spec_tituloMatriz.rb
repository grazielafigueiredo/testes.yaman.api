context 'Criar 24 concursos MAX' do
    before do
          
        # o =  Database.new.insert_create_serie
        o =  Database.new.relacionamento_serie_concurso
    end

  
    it { 
    }
  
end
context 'Verificar quantidade de títulos gerados do MAX (82160)' do
    before do
          
       o =  Database.new.select_count_generated_titulos
       puts o.do
    end
  
    it {        Database.new.select_count_generated_titulos
    }
  
end