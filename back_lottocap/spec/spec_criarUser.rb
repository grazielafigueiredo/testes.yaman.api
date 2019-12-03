describe 'Criar usuário' do

    context 'Sucesso' do
      before do
        @token = ApiUser.GetToken
        @create = ApiCreateUser.post_createUser(@token, Faker::Name.name,Faker::CPF.numeric, Faker::Internet.email)
    end

      it { expect(JSON.parse(@create.response.body)['sucesso']).to be true}
      it { puts @create.response.body}

      after do
        ApiUser.get_deslogar(@token)
      end
    end

    context 'CPF já cadastrado' do
        before do
            @token = ApiUser.GetToken
            @create = ApiCreateUser.post_createUser(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiUser.GetToken
          @create = ApiCreateUser.post_createUser(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiUser.GetToken
          @create = ApiCreateUser.post_createUser(@token, Faker::Name.name, Faker::CPF.numeric, "hklhl@hkhllk.com")
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
          @create = ApiCreateUser.post_validarUser(@token, Faker::Name.name, Faker::CPF.numeric, Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['sucesso']).to be true}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'CPF já cadastrado' do
        before do
            @token = ApiUser.GetToken
            @create = ApiCreateUser.post_validarUser(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiUser.GetToken
          @create = ApiCreateUser.post_validarUser(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiUser.GetToken
          @create = ApiCreateUser.post_validarUser(@token, Faker::Name.name, Faker::CPF.numeric, "hklhl@hkhllk.com")
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end
end 