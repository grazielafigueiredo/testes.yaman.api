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
    expect((@login.response.code)).to be 401

    @token = ApiUser.GetToken
    @loginNovamente = ApiUser.Login(@token, Constant::User1)
    puts @loginNovamente
  end

  it 'validacao de login' do
    expect((@loginNovamente.parsed_response)['erros']).to eql []
    expect((@loginNovamente.parsed_response)['sucesso']).to eql true
    expect((@loginNovamente.response.code)).to be 200
  end
  after do
    ApiUser.get_logout(@token)
  end
end
