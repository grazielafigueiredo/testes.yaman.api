require 'base64'


Before('@login') do
    visit '/homolog'
    find('div[class="Header__login"]').click
    sleep(2)
    fill_in 'email', with: "user1@gmail.com"
    fill_in 'password', with: "1234"
    find(:css, 'button[type="submit"]').click
    exists_modal = page.has_selector?('#onesignal-popover-container')
    sleep(2)

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
end 

After do |scenario|
    
    if screenshot.failed?
        shot_file  = page.save_screenshot("log/screenshot.png")
        shot_b64 = Base64.encode64(File.open(shot_file, "rb").read)
        embed(shot_b64, "image/png", "Screenshot") #cucumber anexa screenshot no report
    end
end

