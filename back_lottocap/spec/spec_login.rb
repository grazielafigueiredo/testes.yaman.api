# frozen_string_literal: true

context 'Erro 400 API Logar Usuário - só resolveu limpando service worker' do
  before do
    @token = ApiUser.GetToken
    ApiUser.Login(@token, Constant::User1)

    def execute_script
      js_script = 'window.localStorage.setItem("tokenAutenticado", "false");'
      token = page.execute_script(js_script)
      expect(token).to eql 'false'
      puts js_script
    end

    @login = ApiUser.Login(@token, Constant::User1)
    expect(JSON.parse(@login.response.code)).to be 401

    @token = ApiUser.GetToken
    @loginNovamente = ApiUser.Login(@token, Constant::User1)
    puts @loginNovamente
  end

  it 'validacao de login' do
    expect(JSON.parse(@loginNovamente.response.body)['erros']).to eql []
    expect(JSON.parse(@loginNovamente.response.body)['sucesso']).to eql true
    expect(JSON.parse(@loginNovamente.response.code)).to be 200
  end
  after do
    ApiUser.get_deslogar(@token)
  end
end
