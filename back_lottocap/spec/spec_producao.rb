#frozen_string_literal: true

describe 'Criar usuário' do

    context 'CPF já cadastrado' do
        before do
            @token = ApiProducao.GetToken
            @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        puts @create  
        puts @token
        end
  
        it { expect((@create.parsed_response)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_CadastrarUsuario(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect((@create.parsed_response)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_CadastrarUsuario(@token, Faker::Name.name, Faker::CPF.numeric, "graziela@lottocap.com.br")
        end
  
        it { expect((@create.parsed_response)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end
end

describe 'Validador - 1 passo de criação de usuário' do 
    context 'CPF já cadastrado' do
        before do
            @token = ApiProducao.GetToken
            @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        end
  
        it { expect((@create.parsed_response)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect((@create.parsed_response)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, Faker::CPF.numeric, "graziela@lottocap.com.br")
        end
  
        it { expect((@create.parsed_response)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_logout(@token)
        end
    end
end 


describe 'Alterar dados Usuário' do 
  context 'Alterar cpf para número inválido' do
    before do
      @token = ApiProducao.GetToken
      ApiProducao.Login(@token, Constant::USER)

      @create = ApiProducao.post_alterarDadosUsuario(@token, "graziela@lottocap.com.br", "00000000000")
      puts @create
    end 

    it { expect((@create.parsed_response)['obj.cpf'][0]).to eql "O campo cpf contém dados inválidos."}
  end
  after do
    ApiProducao.get_logout(@token)
  end
end
