Dado("que o usuário possua {string} no carrinho") do |titulos|
    visit 'https://homolog.lottocap.com.br'

    produto = all('div[class="card-vitrine__pacote"]')[0].click # Escolha do produto para compra
    comprar = all('button[class="btn btn-secondary"]')[0].click # click Comprar Créditos
    carrinho = find(:css, 'a[href="/carrinho"]').click # Finalizar compra no carrinho
    sleep(1)
    titulo = find("#qtdSelect > option:nth-child("+ titulos + ")").click # Escolher quantidade de títulos
    sleep(2)
    page.has_selector?('span[class="cart-item__total-price"]') # Verificando preço na página
    expect(page.has_css?('span[class="cart-item__total-price"]')).to eql true

end


Então("liberar o pagamento com Cartão de Crédito com os dados {string}, {string}, {string}, {string}") do |titular, numCartao, validade, cvv|
    find('h4[class="payment-form__title"]').click
    find('input[name="ccTitular"]').set titular
    find('input[name="ccNumero"]').set numCartao
    find('input[name="ccValidade"]').set validade
    find('input[name="ccCodigo"]').set cvv

    opcao_pagamento = find("div.tabs > ol > li:nth-child(2)").click #Button 'Pagar com cartão de crédito'
    botao_pagar = find('button[class="btn btn-secondary"]').click
    sleep(5)
    expect(page).to have_text('Pedido Recebido!') # Verificar mensagem na página
    find('span[class="checkmark"]').set(true) # Checkbox de doação
    find('a[href="/meus-titulos"]').click # Button 'Confirmar e abrir títulos'
    expect(page).to have_text('Atenção ao prazo de expiração da compra:')
    sleep(1)
end

