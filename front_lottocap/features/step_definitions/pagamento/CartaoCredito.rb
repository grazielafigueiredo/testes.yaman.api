Dado("que o usuário possua {string} no carrinho.") do |titulos|
    visit '/homolog'

    produto = all('div[class="card-vitrine__pacote"]')[0].click # Escolha do produto para compra
    comprar = all('button[class="btn btn-secondary"]')[0].click # click Comprar Créditos
    carrinho = find(:css, 'a[href="/carrinho"]').click # Finalizar compra no carrinho
    sleep(1)
    titulo = find("#qtdSelect > option:nth-child("+ titulos + ")").click # Escolher quantidade de títulos
    sleep(2)
    page.has_selector?('span[class="cart-item__total-price"]') # Verificando preço na página
    expect(page.has_css?('span[class="cart-item__total-price"]')).to eql true

end

Então ('deve conferir que as seguintes {string} estão desabilitadas.') do |forma_pagamento_desabilitada|
    pagamentos_bloqueados = all('li[class*="tab-list-item--disabled"]')

    lista_pagamentos_da_tela = []
    for pagamento in pagamentos_bloqueados do
        lista_pagamentos_da_tela.push(pagamento.text)
    end

    expect(lista_pagamentos_da_tela).to match_array(forma_pagamento_desabilitada.split(','))
end

Então("liberar o pagamento com Cartão de Crédito com os dados {string} {string} {string} {string} {string}") do |titular, numCartao, validade, cvv, resultado|
    find('h4[class="payment-form__title"]').click
    find('input[name="ccTitular"]').set titular
    find('input[name="ccNumero"]').set numCartao
    find('input[name="ccValidade"]').set validade
    find('input[name="ccCodigo"]').set cvv

    opcao_pagamento = find("div.tabs > ol > li:nth-child(2)").click #Button 'Pagar com cartão de crédito'
    botao_pagar = find('button[class="btn btn-secondary"]').click
    sleep(5)
    expect(page).to have_text(resultado) # Verificar mensagem na página
    sleep(1)
end