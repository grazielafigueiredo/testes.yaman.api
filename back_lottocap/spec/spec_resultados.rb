# frozen_string_literal: true

context 'Verificar resultados total dos premios' do
  before do
    @token = ApiUser.GetToken


    # pagamentos_bloqueados = all('li[class*="tab-list-item--disabled"]')

    # lista_pagamentos_da_tela = []
    # for pagamento in pagamentos_bloqueados do
    #     lista_pagamentos_da_tela.push(pagamento.text)
    # end

    # expect(lista_pagamentos_da_tela).to match_array(forma_pagamento_desabilitada.split(','))


    @p = ApiResultados.get_GetSerieResultados(@token)
    @t = JSON.parse(@p.response.body)['obj'][0]['resultadoConcurso']['resultadosConcursos'][0]['vlPremioAcerto'][0]
    for i in [] do 
    end

    # puts @result
    end
    it { 
      # expect(JSON.parse(@p.response.body)['obj'][0]['resultadoConcurso']['resultadosConcursos'][0]['vlPremioAcerto'][i]).to be_a Float   
    puts @p
    }
  after do
    ApiUser.get_deslogar(@token)
  end
end

#  fazer o for para verificar se todos os Premios estao vendo com string
