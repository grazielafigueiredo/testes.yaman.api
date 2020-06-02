# frozen_string_literal: true

describe 'Cadastrar um novo usuário' do
  context 'Criação do novo usuário com dados válidos' do
    # before do
    #   @result = ApiCreateUser.post_create_new_user(build(:user).to_hash)
    #   puts @result
    #   # SCRIPT PARA CRIAR USUÁRIOS PARA PERFORMANCE
    #   # (0..100).each do |data|
    #   #   email = Faker::Internet.email
    #   #   @result = ApiCreateUser.post_create_new_user(build(:user).to_hash)
    #   #   puts "#{email},1234"
    #   # end
    # end
    let(:result) { ApiCreateUser.post_create_new_user(build(:user).to_hash) }

    it { expect(result.parsed_response['sucesso']).to be true }
  end

  context 'Tentar registrar com CPF já cadastrado na base' do
    before do
      new_user = build(:user).to_hash
      ApiCreateUser.post_create_new_user(new_user)
      @result = ApiCreateUser.post_create_new_user(new_user)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'." }
  end

  context 'Tentar registrar com E-mail já cadastrado na base' do
    before do
      new_user = build(:user_wrong_email).to_hash
      ApiCreateUser.post_create_new_user(new_user)
      @result = ApiCreateUser.post_create_new_user(new_user)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'." }
  end

  context 'Tentar registrar com CPF numérico sequencial' do
    let(:result) { ApiCreateUser.post_create_new_user(build(:user_wrong_cpf).to_hash) }

    it { expect(result.parsed_response['obj.CPF'][0]).to eql 'O campo CPF contém dados inválidos.' }
  end
end

describe 'Validador - 1 passo de criação de usuário' do
  context 'Validar se os novos dados se e-mail e cpf já possuem cadastro em nossa base' do
    let(:result) { ApiCreateUser.post_validation_data_user(build(:user_validation).to_hash) }

    it { expect(result.parsed_response['sucesso']).to be true }
  end

  context 'Validar se o CPF informada já encontrasse cadastrado em nossa base' do
    before do
      new_user = build(:user_validation_register_cpf).to_hash
      ApiCreateUser.post_validation_data_user(new_user)
      @result = ApiCreateUser.post_validation_data_user(new_user)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'." }
  end

  context 'Validar se o campo CPF bloqueia input com números sequenciais' do
    let(:result) { ApiCreateUser.post_validation_data_user(build(:user_validation_wrong_cpf).to_hash) }

    it { expect(result.parsed_response['obj.CPF'][0]).to eql 'O campo CPF contém dados inválidos.' }
  end

  context 'Validar se o E-mail informada já encontrasse cadastrado em nossa base' do
    before do
      new_user = build(:user_validation_register_email).to_hash
      ApiCreateUser.post_validation_data_user(new_user)
      @result = ApiCreateUser.post_validation_data_user(new_user)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'." }
  end
end

describe 'Alterar dados do usuário' do
  context 'Alterar e-mail do usuário e verificar se a mudança ocorreu com sucesso' do
    before do
      token = ApiUser.GetToken
      ApiUser.Login(token, build(:login).to_hash)
      change_user = build(:change_user).to_hash
      @result = ApiCreateUser.post_change_user_data(token, change_user)
    end
  
    it { expect(@result.parsed_response['sucesso']).to be true }

    after do
      User.new.update_user_email('otto@gmail.com')
    end
  end

  context 'Alterar e-mail para um e-mail já existente no banco de dados' do
    before do
      token = ApiUser.GetToken
      ApiUser.Login(token, build(:login).to_hash)
      @result = ApiCreateUser.post_change_user_data(token, build(:change_user_email).to_hash)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Não foi possível atualizar seus dados, tente novamente se o erro persistir entre em contato conosco' }
  end

  context 'Input no campo cpf para número inválido e sequencial' do
    before do
      token = ApiUser.GetToken
      ApiUser.Login(token, build(:login).to_hash)
      @result = ApiCreateUser.post_change_user_data(token, build(:change_user_cpf).to_hash)
    end

    it { expect(@result.parsed_response['obj.cpf'][0]).to eql 'O campo cpf contém dados inválidos.' }
  end

  context 'Alterar CPF para um CPF já existente no banco de dados' do
    before do
      token = ApiUser.GetToken
      ApiUser.Login(token, build(:login).to_hash)
      @result = ApiCreateUser.post_change_user_data(token, build(:change_user_cpf_registered).to_hash)
    end

    it { expect(@result.parsed_response['obj.cpf'][0]).to eql 'O campo cpf contém dados inválidos.' }
  end
end
