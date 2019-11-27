dia = ('select[name="bDay"] option:nth-child(2)')
mes = ('select[name="bMonth"] option:nth-child(2)')
ano = ('select[name="bYear"] option:nth-child(31)')
anoInvalido = ('select[name="bYear"] option:nth-child(2)')
  



Dado("que não tenho um cadastro") do
  visit '/homolog'
  cadastro = find("div.Header__button > a").click #button "Cadastre-se"
  # cadastro.click
end

Quando("crio um novo cadastro com {string}, {string}, {string}") do |email, nome, cpf|
  find('input[name="email"]').set Faker::Internet.email
  find('input[name="name"]').set nome
  find('input[name="cpf"]').set CpfUtils.cpf 
  find(:css, 'button[type="submit"]').click
  sleep (2)
end

Então("sou direcionado a criar {string}, {string}") do |senha1, senha2|
  find('[name="password"]').set senha1
  find('[name="confirmPassword"]').set senha2
end

Quando("informo os dados de nascimento dia, mes, ano") do 
  find(dia).click
  find(mes).click
  find(ano).click
  find('#terms').set(true) # Checkbox do Termos de uso
  find(:css, 'button[type="submit"]').click
  sleep(2)
end

Então("verifico a criação do usuário") do
  js_script = 'return window.localStorage.getItem("tokenAutenticado");'
  token = page.execute_script(js_script)
  expect(token).to eql "true"
end

