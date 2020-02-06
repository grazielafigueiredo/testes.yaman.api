Dado("que existe um produto em pré venda") do
    Database.new.update_preVenda
    visit '/homolog'


    # find('div.card-vitrine__bottom > div.card-vitrine__escolha > button]').click #escolha dezenas
    all('div.card-vitrine__bottom > div.card-vitrine__escolha > button')[0].click #escolha dezenas
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(19)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(01)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(14)').click

    sleep 2

    click_button 'Confirmar escolha'
    
    click_button '+ Adicionar título'
    
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(19)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(01)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(14)').click
    # find('button[class="escolhaModal__btn escolhaModal__btn--escolha"]').click
    # select 'ul > li:nth-child(5)', from: '5'
    click_button 'Confirmar escolha'
    sleep 5


    find('div[class="Toastify__toast-body"]').hover
    # expect(page).to 
    
end
  
Quando("escolho as dezenas, volto para vitrine e add mais títulos") do


end
  
Então("finalizo a venda") do
end