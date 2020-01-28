require 'base64'


Before('@login') do
    visit '/homolog'
    find('div[class="Header__login"]').click
    # sleep(2)
    fill_in 'email', with: "user22@gmail.com"
    fill_in 'password', with: "1234"
    find(:css, 'button[type="submit"]').click
    exists_modal = page.has_selector?('#onesignal-popover-container')
    # sleep(2)

    # page.driver.browser.witch_to.alert.dismiss
    exists_modal = page.has_selector?('#onesignal-popover-container')
    if exists_modal
        popover_no = find('#onesignal-popover-cancel-button')
        popover_no.click
    end      
end

Before('@loginboleto') do
    visit '/homolog'
    find('div[class="Header__login"]').click
    sleep(2)
    fill_in 'email', with: "graziela@lottocap.com.br"
    fill_in 'password', with: "lottocap"
    find(:css, 'button[type="submit"]').click
    sleep(2)

    # page.driver.browser.witch_to.alert.dismiss

    exists_modal = page.has_selector?('#onesignal-popover-container')
    if exists_modal
        popover_no = find('#onesignal-popover-cancel-button')
        popover_no.click
    end   
end

After('@deslogar') do
    exists_modal = page.has_selector?('#onesignal-popover-container')
    if exists_modal
        popover_no = find('#onesignal-popover-cancel-button')
        popover_no.click
    end

    # page.driver.browser.witch_to.alert.dismiss


    find('.userActive__circle--avatar').click
    find('.dropMenu__list a[href="/logout"]').click
    sleep (6)
end 

Before ('@vitrine') do 
    # produto = all('div[class="card-vitrine__pacote"]')[3].click # Escolha do produto para compra
    comprar = all('div[class="card-vitrine__pacote"]')[8].click # click Comprar Créditos
    carrinho = find(:css, 'a[href="/carrinho"]').click # Finalizar compra no carrinho
    # sleep(1)
    titulo = find("#qtdSelect > option:nth-child("+ titulos +")").click # Escolher quantidade de títulos
    # sleep(2)
    # page.has_selector?('span[class="cart-item__total-price"]') # Verificando preço na página
    # expect(page.has_css?('span[class="cart-item__total-price"]')).to eql true
    
end


