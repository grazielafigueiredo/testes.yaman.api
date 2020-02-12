Dado("que adiciono um max regular no carrinho e um pré venda") do
    Database.new.update_preVenda
    visit '/homolog'

    all('div[class*="card-vitrine__pacote"]')[].click #escolher dezenas
    all('div.card-vitrine__bottom > div.card-vitrine__escolha > button')[5].click #escolher dezenas
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(19)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(01)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(80)').click
end

Quando("vou confirmar se as opcões {string} estao bloqueadas") do |forma_pagamento_desabilitada|
    pagamentos_bloqueados = all('li[class*="tab-list-item--disabled"]')

    lista_pagamentos_da_tela = []
    for pagamento in pagamentos_bloqueados do
        lista_pagamentos_da_tela.push(pagamento.text)
    end

    expect(lista_pagamentos_da_tela).to match_array(forma_pagamento_desabilitada.split(','))
end

Então("compro os títulos no cartão de crédito") do
    all('li[class*="tab-list-item"]')[1].click
    click_button 'Pagar com cartão de crédito'
end