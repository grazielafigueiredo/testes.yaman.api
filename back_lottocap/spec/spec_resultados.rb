# frozen_string_literal: true

context 'Verificar resultados total dos premios' do
  before do
    @token = ApiUser.GetToken

    # puts @token
    @p = ApiResultados.get_GetSeriesListResultados(@token)

    # puts @result
    end
    it { 
      expect(JSON.parse(@p.response.body)['obj']['dadosSerie']['resultadosConcursos'][0]['vlPremioAcerto']).to eql 13875.0 
    }
  after do
    ApiUser.get_deslogar(@token)
  end
end
