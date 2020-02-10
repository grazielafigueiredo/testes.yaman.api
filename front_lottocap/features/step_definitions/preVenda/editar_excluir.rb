Dado("que adiciono mais um título de pré venda") do
    Database.new.update_preVenda
    visit '/homolog'

    all('div.card-vitrine__bottom > div.card-vitrine__escolha > button')[0].click #escolher dezenas
    dezenas_selecionadas_vazias = all('li[class*="empty"]')
    a = ["", "", ""]

    dezenas_vazias = []
    for dezena_vazia in dezenas_selecionadas_vazias do
        dezenas_vazias.push(dezena_vazia.text)
    end

    expect(dezenas_vazias).to match_array(a)

    click_button 'Aleatório'

    click_button 'Confirmar escolha'

    click_button '+ Adicionar título'
    
    click_button 'Aleatório'

    click_button 'Confirmar escolha'

    mensagem_modal = find('div.escolhaModal__bottom > span')
    # mensagem_modal.hover
    # expect(page).to have_text '\n2\ntítulos'
end
  
Quando("edito as dezenas mudam") do
   all("body > div.ReactModalPortal > div > div > div.escolhaModal__body.escolhaModal__body--lista > ul > li > span:nth-child(3)")[1].click

   sleep 3
    click_button 'Aleatório'

    click_button 'Confirmar escolha'
end
  
Então("posso excluir") do
    all("body > div.ReactModalPortal > div > div > div.escolhaModal__body.escolhaModal__body--lista > ul > li > span:nth-child(4)")[1].click
    sleep 3
    click_button 'Cancelar'

    all("body > div.ReactModalPortal > div > div > div.escolhaModal__body.escolhaModal__body--lista > ul > li > span:nth-child(4)")[1].click
    click_button 'Excluir'
    sleep 3

end