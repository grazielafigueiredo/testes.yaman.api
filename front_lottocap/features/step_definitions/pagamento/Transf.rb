Dado("que o usuário apresente {string} no carrinho.") do |titulos|
    visit '/homolog'

    titulo = find("#qtdSelect > option:nth-child("+ titulos + ")").click # Escolher quantidade de títulos
    sleep(2)
    page.has_selector?('span[class="cart-item__total-price"]') # Verificando preço na página
    expect(page.has_css?('span[class="cart-item__total-price"]')).to eql true

end


Então ('deve apresentar as seguintes {string}') do |forma_pagamento_desabilitada|
    pagamentos_bloqueados = all('li[class*="tab-list-item--disabled"]')

    lista_pagamentos_da_tela = []
    for pagamento in pagamentos_bloqueados do
        lista_pagamentos_da_tela.push(pagamento.text)
    end

    expect(lista_pagamentos_da_tela).to match_array(forma_pagamento_desabilitada.split(','))
end
