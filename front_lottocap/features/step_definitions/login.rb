
Dado("que o usuário possa acessar a tela de login do sistema") do
  visit '/homolog'

  find('div[class="Header__login"]').click
  sleep(1)
end

Quando("eu faço login com um {string} e {string}") do |email, senha|
  find('[name="email"]').set email
  find('[name="password"]').set senha
  find(:css, 'button[type="submit"]').click
  sleep(1)
end

Então("verifico {string} dos dados inseridos.") do |resultado|
  expect(page).to have_text resultado
end

Então("verifico se o usuário está logado {string}") do |resultado|
  js_script = 'return window.localStorage.getItem("tokenAutenticado");'
  token = page.execute_script(js_script)
  expect(token).to eql "true"
end


# js_script ='window.localStorage.setItem("onesignal-notification-prompt", '{"value":"\"dismissed\"","timestamp":1576112844844}');'
# page.execute_script(js_script)


# {"value":"\"dismissed\"","timestamp":1576112844844}