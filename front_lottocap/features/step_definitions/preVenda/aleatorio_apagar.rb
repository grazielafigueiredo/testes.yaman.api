Dado("que adiciono um produto que esteja em pré venda") do
    Database.new.update_preVenda
    visit '/homolog'
end
  
Quando("escolho as dezenas de forma aleatória") do
    all('div.card-vitrine__bottom > div.card-vitrine__escolha > button')[0].click #escolher dezenas
    dezenas_selecionadas_vazias = all('li[class*="empty"]')
    a = ["", "", ""]

    dezenas_vazias = []
    for dezena_vazia in dezenas_selecionadas_vazias do
        dezenas_vazias.push(dezena_vazia.text)
    end

    expect(dezenas_vazias).to match_array(a)

    click_button 'Aleatório'
end

Então("posso apagar e adicionar outras dezenas") do

    dezenas_selecionadas_vazias = all('li[class*="gjgjgjgjh"]')
    a = []

    dezenas_vazias = []
    for dezena_vazia in dezenas_selecionadas_vazias do
        dezenas_vazias.push(dezena_vazia.text)
    end

    # expect(dezenas_vazias).to match_array(a)
    expect(a).to match_array(dezenas_vazias)
    sleep 4
    click_button ('Apagar')
    sleep 4

    dezenas_selecionadas_vazias = all('li[class*="empty"]')
    a = [""]

    dezenas_vazias = []
    for dezena_vazia in dezenas_selecionadas_vazias do
        dezenas_vazias.push(dezena_vazia.text)
    end

    expect(dezenas_vazias).to match_array(a)

    click_button ('Apagar')
    sleep 4
    


    dezenas_selecionadas_vazias = all('li[class*="empty"]')
    a = ["", ""]

    dezenas_vazias = []
    for dezena_vazia in dezenas_selecionadas_vazias do
        dezenas_vazias.push(dezena_vazia.text)
    end

    expect(dezenas_vazias).to match_array(a)

    click_button ('Apagar')
    sleep 4
    
    dezenas_selecionadas_vazias = all('li[class*="empty"]')
    a = ["", "", ""]

    dezenas_vazias = []
    for dezena_vazia in dezenas_selecionadas_vazias do
        dezenas_vazias.push(dezena_vazia.text)
    end

    expect(dezenas_vazias).to match_array(a)

    click_button 'Aleatório'
    mensagem_modal = find('div.escolhaModal__body.escolhaModal__body--escolha.escolhaModal__body--fixed > span')
    mensagem_modal.hover
    expect(mensagem_modal).to have_text('Ótima escolha, boa sorte! 🍀')
   
    click_button 'Confirmar escolha'
end