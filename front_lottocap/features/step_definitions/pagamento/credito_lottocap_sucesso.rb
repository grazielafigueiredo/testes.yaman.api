Dado("que o usuário disponha de {string} no carrinho") do |titulos|
    Database.new.update_creditoLottocap(100)

    titulo = find("#qtdSelect > option:nth-child("+ titulos +")").click # Escolher quantidade de títulos
end

Então('liberar o pagamento com crédito lottocap') do
    opcao_boleto = find("div.tabs > ol > li:nth-child(1)").click #Button 'Pagar com crédito Lottocap'
    botao_pagar = find('button[class="btn btn-secondary"]').click
    sleep(3)
    expect(page).to have_text('Pedido Recebido!') # Verificar mensagem na página
    find('span[class="checkmark"]').set(true) # Checkbox de doação
    find('a[href="/meus-titulos"]').click # Button 'Confirmar e abrir títulos'
    sleep(1)
end