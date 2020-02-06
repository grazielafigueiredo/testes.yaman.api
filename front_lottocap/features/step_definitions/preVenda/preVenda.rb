Dado("que existe um produto em pré venda") do
    Database.new.update_preVenda
    visit '/homolog'
end
  
Quando("escolho as dezenas e confirmo") do

    all('div.card-vitrine__bottom > div.card-vitrine__escolha > button')[0].click #escolher dezenas
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(19)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(01)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(80)').click

    sleep 2

    click_button 'Confirmar escolha'
    click_button '+ Adicionar título'
end
  
Então("adiciono as mesmas dezenas e sou impedida de confirmar") do
    
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(19)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(01)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(80)').click

    click_button 'Confirmar escolha'
    sleep 5

    toasti = find('div[class="Toastify__toast-body"]')
    toasti.hover
    # expect(toasti).to have_text('Você já adicionou um título com essas dezenas. Faça uma nova escolha.').trim()
end