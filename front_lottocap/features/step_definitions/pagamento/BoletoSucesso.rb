
Dado("que o usuário tenha {string} no carrinho") do |titulos|
    visit '/homolog'
    

    titulo = find("#qtdSelect > option:nth-child("+ titulos + ")").click # Escolher quantidade de títulos
    sleep(2)
    page.has_selector?('span[class="cart-item__total-price"]') # Verificando preço na página
    expect(page.has_css?('span[class="cart-item__total-price"]')).to eql true

end

Então("liberar o pagamento com boleto e {string} da confirmação") do |resultado|
    opcao_boleto = find("div.tabs > ol > li:nth-child(4)").click #Button 'Pagar com boleto'
    botao_pagar = find('button[class="btn btn-secondary"]').click
    sleep(3)
    expect(page).to have_text(resultado)
    expect(page).to have_text('Pedido Recebido!') # Verificar mensagem na página
    find('span[class="checkmark"]').set(true) # Checkbox de doação
    find('a[class="btn btn-secondary"]').click # Button 'Confirmar e ver boleto
    expect(page).to have_text('Agora falta pouco para você concorrer! Próximo passo: faça o pagamento do boleto')
    sleep(1)
end

