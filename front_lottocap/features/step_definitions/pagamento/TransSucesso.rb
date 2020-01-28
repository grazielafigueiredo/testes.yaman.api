Dado("que o usuário contenha {string} no carrinho") do |titulos|
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


Então("liberar o pagamento com transferência {string}, {string}, {string}, {string}") do |titular, agencia, conta, digitoConta|
    opcao_pagamento = find("div.tabs > ol > li:nth-child(3)").click #Button 'Pagar com transferência'
    

    adicionar_banco = find('[class="payment-form__title"]').click
    banco = find('ul[class="pick-banco"] li:nth-child(1)').click #banco para transferência
    find('input[name="titular"]').set titular
    find('input[name="agencia"]').set agencia
    find('input[name="conta"]').set conta
    find('input[name="digitoConta"]').set digitoConta

    botao_pagar = find('button[class="btn btn-secondary"]').click
    sleep(3)
    expect(page).to have_text('Pedido Recebido!') # Verificar mensagem na página
    find('span[class="checkmark"]').set(true) # Checkbox de doação
    find('a[href="/meus-titulos"]').click # Button 'Confirmar e abrir títulos'
    sleep(1)
end