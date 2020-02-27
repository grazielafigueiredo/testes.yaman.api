#frozen_string_literal: true

context 'Resultados' do
  before do
    @token = ApiUser.GetToken

    @getSerieResultados = ApiResultados.get_serieResultados(@token, 91)
    @vlPremioAcerto = JSON.parse(@getSerieResultados.response.body)['obj'][0]['resultadoConcurso']['resultadosConcursos']
    puts @vlPremioAcerto.count 
  end
  
  it 'Premio total e por acertos nao pode retornar Zero' do 
    @vlPremioAcerto.each do | premio|
      expect(premio['vlPremioAcerto']).to be_a Float
      expect(premio['vlPremioAcerto']).to be >= 1.0
      expect(premio['vlPremioConcurso']).to be_a Float
      expect(premio['vlPremioConcurso']).to be >= 1.0
    end
  end

  after do
    ApiUser.get_deslogar(@token)
  end
end