#frozen_string_literal: true

describe 'Criar usuário' do

    context 'CPF já cadastrado' do
        before do
            @token = ApiProducao.GetToken
            @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        puts @create  
        puts @token
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_deslogar(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_CadastrarUsuario(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiProducao.get_deslogar(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_CadastrarUsuario(@token, Faker::Name.name, Faker::CPF.numeric, "graziela@lottocap.com.br")
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_deslogar(@token)
        end
    end
end

describe 'Validador - 1 passo de criação de usuário' do 
    context 'CPF já cadastrado' do
        before do
            @token = ApiProducao.GetToken
            @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_deslogar(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiProducao.get_deslogar(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiProducao.GetToken
          @create = ApiProducao.post_validarDadosUsuarioCriacao(@token, Faker::Name.name, Faker::CPF.numeric, "graziela@lottocap.com.br")
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiProducao.get_deslogar(@token)
        end
    end
end 


describe 'Alterar dados Usuário' do 
  context 'Alterar cpf para número inválido' do
    before do
      @token = ApiProducao.GetToken
      ApiProducao.Login(@token, Constant::User1)

      @create = ApiProducao.post_alterarDadosUsuario(@token, "graziela@lottocap.com.br", "00000000000")
      puts @create
    end 

    it { expect(JSON.parse(@create.response.body)['obj.cpf'][0]).to eql "O campo cpf contém dados inválidos."}
  end
  after do
    ApiProducao.get_deslogar(@token)
  end
end



context 'Resultados' do
  before do
    @token = ApiUser.GetToken

    @getSerieResultados = ApiResultados.get_serieResultados(@token, 29)
    @vlPremioAcerto = JSON.parse(@getSerieResultados.response.body)['obj'][0]['resultadoConcurso']['resultadosConcursos']
    puts @vlPremioAcerto.count
  end
  
  it 'Premio total e por acertos nao pode retornar Zero' do 
    @vlPremioAcerto.each do | premio|
      expect(premio['vlPremioAcerto']).to be_a Float
      expect(premio['vlPremioAcerto']).to be >= 1.0
      expect(premio['vlPremioConcurso']).to be_a Float
      expect(premio['vlPremioConcurso']).to be >= 1.0
    end
  end

  after do
    ApiUser.get_deslogar(@token)
  end
end