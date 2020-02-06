Dado("que o usuário disponha de {string} no carrinho.") do |titulos|

        Database.new.update_creditoLottocap(100)

    titulo = find("#qtdSelect > option:nth-child("+ titulos +")").click # Escolher quantidade de títulos
end


Então('deve analisar que as seguintes {string} estão desabilitadas.') do |forma_pagamento_desabilitada|
    pagamentos_bloqueados = all('li[class*="tab-list-item--disabled"]')
    
    lista_pagamentos_da_tela = []
    for pagamento in pagamentos_bloqueados do
        lista_pagamentos_da_tela.push(pagamento.text)
    end
    
    expect(lista_pagamentos_da_tela).to match_array(forma_pagamento_desabilitada.split(','))
    
end
    def data
        Database.new.update_creditoLottocap(0)
    end