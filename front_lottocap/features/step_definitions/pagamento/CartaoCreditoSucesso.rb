Dado("que o usuário possua {string} no carrinho") do |titulos|

    titulo = find("#qtdSelect > option:nth-child("+ titulos + ")").click # Escolher quantidade de títulos

end


Então("liberar o pagamento com Cartão de Crédito com os dados {string}, {string}, {string}, {string}") do |titular, numCartao, validade, cvv|
    opcao_pagamento = find("div.tabs > ol > li:nth-child(2)").click #Button 'Pagar com cartão de crédito'
    find('h4[class="payment-form__title"]').click
    find('input[name="ccTitular"]').set titular
    find('input[name="ccNumero"]').set numCartao
    find('input[name="ccValidade"]').set validade
    find('input[name="ccCodigo"]').set cvv

    botao_pagar = find('button[class="btn btn-secondary"]').click
    sleep(5)
    expect(page).to have_text('Pedido Recebido!') # Verificar mensagem na página
    find('span[class="checkmark"]').set(true) # Checkbox de doação
    find('a[href="/meus-titulos"]').click # Button 'Confirmar e abrir títulos'
    expect(page).to have_text('Atenção ao prazo de expiração da compra:')
    sleep(1)
end

