#frozen_string_literal: true

describe 'Criar usuário' do

    context 'CPF já cadastrado' do
        before do
            @token = ApiProducao.GetToken
            @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        puts @create  
        puts @token
        end
  
        it { expect((@create.parsed_response)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_CadastrarUsuario(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect((@create.parsed_response)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_CadastrarUsuario(@token, Faker::Name.name, Faker::CPF.numeric, "graziela@lottocap.com.br")
        end
  
        it { expect((@create.parsed_response)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end
end

describe 'Validador - 1 passo de criação de usuário' do 
    context 'CPF já cadastrado' do
        before do
            @token = ApiProducao.GetToken
            @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        end
  
        it { expect((@create.parsed_response)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect((@create.parsed_response)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, Faker::CPF.numeric, "graziela@lottocap.com.br")
        end
  
        it { expect((@create.parsed_response)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end
end 


describe 'Alterar dados Usuário' do 
  context 'Alterar cpf para número inválido' do
    before do
      @token = ApiProducao.GetToken
      ApiProducao.Login(@token, Constant::User1)

      @create = ApiProducao.post_alterarDadosUsuario(@token, "graziela@lottocap.com.br", "00000000000")
      puts @create
    end 

    it { expect((@create.parsed_response)['obj.cpf'][0]).to eql "O campo cpf contém dados inválidos."}
  end
  after do
    ApiProducao.get_logout(@token)
  end
end


# context 'home - GetRankingResultados' do 
#   before do 
#     @token = ApiUser.GetToken
#     @rankingResultados = ApiRanking.get_rankingResultados(@token)
#     @totalPremiados = (@rankingResultados.parsed_response)['obj']
#     @bodyListaSeries = (@rankingResultados.parsed_response)['obj'][0]['listaSeries']
#     @bodyTitulosPorSerie = (@rankingResultados.parsed_response)['obj'][0]['titulosPorSerie']
#     @detalhesTitulosPorSerie = (@rankingResultados.parsed_response)['obj'][0]['detalhesTitulosPorSerie']
#     @contemplacao = (@rankingResultados.parsed_response)['obj'][0]['contemplacao']
#     @concursos = (@rankingResultados.parsed_response)['obj'][0]['concursos']
#     puts @bodyListaSeries.count
#   end
#   it 'home - GetRankingResultados' do 
#     @bodyListaSeries.each do |listaSeries|
#       expect(listaSeries['idSerie']).to be_a_kind_of(Integer)
#       expect(listaSeries['idSerie']).to be >= 1
#       expect(listaSeries['nmSerie']).to be_a_kind_of(String)
#       expect(listaSeries['nmSerie'].length).to be >= 1
#       expect(listaSeries['destaque']).to be(true).or be(false)
#       expect(listaSeries['preSelecionada']).to be(true).or be(false)
#       expect(listaSeries['dataInicialVigencia']).to be_a_kind_of(String)
#       expect(listaSeries['dataFinalVigencia']).to be_a_kind_of(String)
#     end

#     @bodyTitulosPorSerie.each do |tituloPorSerie|
#       expect(tituloPorSerie['idSerie']).to be_a_kind_of(Integer)
#       # expect(tituloPorSerie['idSerie'].length).to be >= 1.0
#       # expect(tituloPorSerie['pontosGanhadores']).to be >= 1.0 
#       expect(tituloPorSerie['qtTitulos']).to be >= 1.0 
#     end
    
#     @detalhesTitulosPorSerie.each do |detalhePorSerie|
#       expect(detalhePorSerie['idSerie']).to be_a_kind_of(Integer)
#       expect(detalhePorSerie['idSerie']).to be >= 1
#       # expect(detalhePorSerie['valorPremiado']).to be >= 1.0 
#       expect(detalhePorSerie['nmTituloFixo']).to be >= 1.0 
#     end

#     @contemplacao.each do |totalContemplacao|
#       expect(totalContemplacao['qtdeContemplacaoObrigatoria']).to be >= 1.0 
#       expect(totalContemplacao['qtdeTitulosVendidos']).to be >= 1.0 
#       expect(totalContemplacao['qtdeTitulosMaisPontosVendidos']).to be >= 0 
#     end

#     @concursos.each do |concurso|
#       expect(concurso['nmConcurso']).to be_a_kind_of(String)
#       expect(concurso['nmConcurso'].length).to be >= 1
#       expect(concurso['vlPremios']).to be_a_kind_of(Float)
#       expect(concurso['flagMaisPontos']).to be(true).or be(false)
#     end
#     expect((@concursos).count).to be >= 23

#     expect((@totalPremiados)[0]['flContemplacaoObrigatoria']).to be(true).or be(false)
#     expect((@totalPremiados)[0]['qtdeSubscritoresMaisPontosVendidos']).to be_a_kind_of(Integer)
#     expect((@totalPremiados)[0]['vlTotalPremiado']).to be >= 1.0
#     expect((@totalPremiados)[0]['qtdeTotalSorteios']).to be >= 23
#     expect((@totalPremiados)[0]['qtdeSorteiosRealizados']).to be >= 1.0
#   end

#   after do
#     ApiUser.get_logout(@token)
#   end
# end

# context 'Resultados por Serie' do 
#   before do 
#     @token = ApiUser.GetToken
#     @rankingResultadosPorSerie = ApiRanking.post_rankingResultadosPorSerie(@token)
#     @totalPremiados = (@rankingResultadosPorSerie.parsed_response)['obj']
#     @titulosPorSerie = (@rankingResultadosPorSerie.parsed_response)['obj'][0]['titulosPorSerie']
#     @detalhesTitulosPorSerie = (@rankingResultadosPorSerie.parsed_response)['obj'][0]['detalhesTitulosPorSerie']
#     @contemplacao = (@rankingResultadosPorSerie.parsed_response)['obj'][0]['contemplacao']
#     @concursos = (@rankingResultadosPorSerie.parsed_response)['obj'][0]['concursos']
#   end

#   it 'Resultados por Serie' do 
#     # expect((@rankingResultadosPorSerie)['obj'][0]['listaSeries']).to be_nil
#     @titulosPorSerie.each do |serie|
#       expect(serie['idSerie']).to be_a_kind_of(Integer)
#       expect(serie['idSerie']).to be >= 1.0
#       expect(serie['pontosGanhadores']).to be >= 1.0
#       expect(serie['qtTitulos']).to be >= 1.0
#     end
    
#     @detalhesTitulosPorSerie.each do |detalheTitulo|
#       expect(detalheTitulo['idSerie']).to be_a_kind_of(Integer)
#       expect(detalheTitulo['idSerie']).to be >= 1.0
#       expect(detalheTitulo['valorPremiado']).to be >= 1.0
#       expect(detalheTitulo['nmTituloFixo']).to be_a_kind_of(Integer)
#       expect(detalheTitulo['nmTituloFixo']).to be >= 1.0
#     end
#     @contemplacao.each do |totalContemplacao|
#       expect(totalContemplacao['qtdeContemplacaoObrigatoria']).to be >= 1.0 
#       expect(totalContemplacao['qtdeTitulosVendidos']).to be >= 1.0 
#       expect(totalContemplacao['qtdeTitulosMaisPontosVendidos']).to be >= 1.0 
#     end

#     @concursos.each do |concurso|
#       expect(concurso['nmConcurso']).to be_a_kind_of(String)
#       expect(concurso['nmConcurso'].length).to be >= 1
#       expect(concurso['vlPremios']).to be >= 1.0 
#       expect(concurso['flagMaisPontos']).to be(true).or be(false)
#     end

#     expect((@totalPremiados)[0]['flContemplacaoObrigatoria']).to be(true).or be(false)
#     expect((@totalPremiados)[0]['qtdeSubscritoresMaisPontosVendidos']).to be >= 1.0
#     expect((@totalPremiados)[0]['vlTotalPremiado']).to be >= 1.0
#     expect((@totalPremiados)[0]['qtdeTotalSorteios']).to be >= 23
#     expect((@totalPremiados)[0]['qtdeSorteiosRealizados']).to be >= 1.0
#   end
#   after do
#     ApiUser.get_logout(@token)
#   end
# end

# context 'Modal Premiado' do 
#   before do 
#     @token = ApiUser.GetToken
#     @modalPremiado = ApiRanking.get_modalPremiado(@token)
#     @outrosTitulosMesmaPontuacao = (@modalPremiado.parsed_response)['obj'][0]['outrosTitulosMesmaPontuacao']
#   end
#  it 'Modal 5 melhores premiado' do
#   @outrosTitulosMesmaPontuacao.each do |outroTitulo|
#     expect(outroTitulo['idSerie']).to be_a_kind_of(Integer)
#     expect(outroTitulo['idSerie']).to be >= 1.0
#     expect(outroTitulo['nmTituloFixo']).to be_a_kind_of(String)
#     expect(outroTitulo['nmTituloFixo'].length).to be >= 1
#     expect(outroTitulo['pontosGanhadores']).to be >= 1.0 
#   end
#     expect((@outrosTitulosMesmaPontuacao).count).to eql 4
#   end

#    after do
#     ApiUser.get_logout(@token)
#   end
# end

# context 'Sorteios resultados' do 
#   before do 
#     @token = ApiUser.GetToken
#     @sorteiosResultados = ApiRanking.get_sorteiosResultados(@token)
#     @resultadosConcursos = (@sorteiosResultados.parsed_response)['obj'][0]['resultadosConcursos']
#   end
#  it 'Sorteios' do
#   @resultadosConcursos.each do |resultado|
#     expect(resultado['idSerie']).to be_a_kind_of(Integer)
#     expect(resultado['idSerie']).to be >= 1.0
#     expect(resultado['nmSerie']).to be_a_kind_of(String)
#     expect(resultado['nmSerie'].length).to be >= 1
#     expect(resultado['dtSorteio']).to be_a_kind_of(String) 
#     expect(resultado['dtSorteio'].length).to be >= 1 
#     expect(resultado['resultadoConcurso']).to be_a_kind_of(String)
#     expect(resultado['resultadoConcurso'].length).to be >= 1
#     expect(resultado['vlPremioConcurso']).to be >= 1.0 
#     expect(resultado['tipoAcerto']).to be_a_kind_of(String)
#     expect(resultado['tipoAcerto'].length).to be >= 1
#     expect(resultado['vlPremioAcerto']).to be >= 1.0 
#     expect(resultado['titulosPremiados']).to be >= 1.0 
#     expect(resultado['flagMaisPontos']).to be(true).or be(false)
#   end
#  end

#   after do
#     ApiUser.get_logout(@token)
#   end 
# end

# context 'Sorteios resultados' do 
#   before do 
#     @token = ApiUser.GetToken
#     @modalRankingPorPontos = ApiRanking.get_modalRankingPorPontos(@token)
#     @outrosTitulosMesmaPontuacao = (@modalRankingPorPontos.parsed_response)['obj'][0]['outrosTitulosMesmaPontuacao']
#   end
#   it 'Modal 5 melhores premiado' do
#     @outrosTitulosMesmaPontuacao.each do |outroTitulo|
#       expect(outroTitulo['idSerie']).to be_a_kind_of(Integer)
#       expect(outroTitulo['idSerie']).to be >= 1.0
#       expect(outroTitulo['nmTituloFixo']).to be_a_kind_of(String)
#       expect(outroTitulo['nmTituloFixo'].length).to be >= 1
#       expect(outroTitulo['pontosGanhadores']).to be >= 1.0 
#     end
#       expect((@outrosTitulosMesmaPontuacao).count).to eql 4
#   end

#   after do
#     ApiUser.get_logout(@token)
#   end 
# end