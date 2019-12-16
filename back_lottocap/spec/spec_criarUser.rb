describe 'Criar usuário' do

    context 'Sucesso' do
      before do
        @token = ApiUser.GetToken
        @create = ApiCreateUser.post_CadastrarUsuario(@token, Faker::Name.name,Faker::CPF.numeric, Faker::Internet.email)
        puts @create
      end

      it { expect(JSON.parse(@create.response.body)['sucesso']).to be true}

      after do
        ApiUser.get_deslogar(@token)
      end
    end

    context 'CPF já cadastrado' do
        before do
            @token = ApiUser.GetToken
            @create = ApiCreateUser.post_CadastrarUsuario(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiUser.GetToken
          @create = ApiCreateUser.post_CadastrarUsuario(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiUser.GetToken
          @create = ApiCreateUser.post_CadastrarUsuario(@token, Faker::Name.name, Faker::CPF.numeric, "hklhl@hkhllk.com")
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end
end

describe 'Validador - 1 passo de criação de usuário' do 
    context 'Sucesso' do
        before do
          @token = ApiUser.GetToken
          @create = ApiCreateUser.post_ValidarDadosUsuarioCriacao(@token, Faker::Name.name, Faker::CPF.numeric, Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['sucesso']).to be true}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'CPF já cadastrado' do
        before do
            @token = ApiUser.GetToken
            @create = ApiCreateUser.post_ValidarDadosUsuarioCriacao(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiUser.GetToken
          @create = ApiCreateUser.post_ValidarDadosUsuarioCriacao(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiUser.GetToken
          @create = ApiCreateUser.post_ValidarDadosUsuarioCriacao(@token, Faker::Name.name, Faker::CPF.numeric, "hklhl@hkhllk.com")
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end
end 


describe 'Alterar dados Usuário' do 
  context 'Sucesso' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      puts @token

      # @create = ApiCreateUser.post_AlterarDadosUsuario(@token, "user22@gmail.com")
      @create = ApiCreateUser.post_AlterarDadosUsuario(@token)
      puts @create
    end 

    it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  end
  after do
    ApiUser.get_deslogar(@token)
  end

  # context 'Alterar e-mail para um e-mail já existente no banco de dados' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)

  #     @cre = ApiCreateUser.post_AlterarDadosUsuario(@token, "user1@gmail.com")
  #     puts @cre
  #   end 

  #   it { expect(JSON.parse(@cre.response.body)['erros'][1]['mensagem']).to eql "Não foi possível atualizar seus dados, tente novamente se o erro persistir entre em contato conosco"}
  # it { puts @cre}
  # end
  # after do
  #   ApiUser.get_deslogar(@token)
  # end
end