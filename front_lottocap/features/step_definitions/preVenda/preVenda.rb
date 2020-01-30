Dado("que existe um produto em pré venda") do
    Database.new.update_preVenda

    # find('div.card-vitrine__bottom > div.card-vitrine__escolha > button]').click #escolha dezenas
    all('div.card-vitrine__bottom > div.card-vitrine__escolha > button')[0].click #escolha dezenas
    sleep 7
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(19)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(01)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(14)').click
    find('div.escolhaModal__body.escolhaModal__body--escolha > ul > li:nth-child(22)').click
    sleep 7
    # select '10', from: 'div.escolhaModal__body.escolhaModal__body--escolha'
    # select '04', from: 'div.escolhaModal__body.escolhaModal__body--escolha'
    # select '11', from: 'div.escolhaModal__body.escolhaModal__body--escolha'
    # select '37', from: 'div.escolhaModal__body.escolhaModal__body--escolha'
    find('button[class="escolhaModal__btn escolhaModal__btn--escolha"]').click
    sleep 7
end
  
Quando("escolho as dezenas, volto para vitrine e add mais títulos") do
end
  
Então("finalizo a venda") do
end