# frozen_string_literal: true

describe '1º passo de criação de usuário' do
  context 'Validar se o CPF informada já encontrasse cadastrado em nossa base' do
    let(:result) { PROD.post_validation_data_user(build(:user_validation_register_cpf).to_hash) }
    it { expect(result.parsed_response['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'." }
  end

  context 'Validar se o campo CPF bloqueia input com números sequenciais' do
    let(:result) { PROD.post_validation_data_user(build(:user_validation_wrong_cpf).to_hash) }
    it { expect(result.parsed_response['obj.CPF'][0]).to eql 'O campo CPF contém dados inválidos.' }
  end

  context 'Validar se o E-mail informada já encontrasse cadastrado em nossa base' do
    before do
      new_user = build(:user_validation_register_email).to_hash
      new_user[:email] = 'graziela@lottocap.com.br'
      @result = PROD.post_validation_data_user(new_user)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'." }
  end
end

describe '2º passo de criação de usuário' do
  context 'Tentar registrar com CPF já cadastrado na base' do
    before do
      new_user = build(:user).to_hash
      new_user[:cpf] = '00000009652'
      @result = PROD.post_create_new_user(new_user)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'." }
  end

  context 'Tentar registrar com E-mail já cadastrado na base' do
    before do
      new_user = build(:user_wrong_email).to_hash
      new_user[:email] = 'graziela@lottocap.com.br'
      @result = PROD.post_create_new_user(new_user)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'." }
  end

  context 'Tentar registrar com CPF numérico sequencial' do
    let(:result) { PROD.post_create_new_user(build(:user_wrong_cpf).to_hash) }
    it { expect(result.parsed_response['obj.CPF'][0]).to eql 'O campo CPF contém dados inválidos.' }
  end
end

describe 'Alterar dados Usuário' do
  context 'Input no campo cpf para número inválido e sequencial' do
    before do
      token = PROD.GetToken
      new_user = build(:login).to_hash
      new_user[:usuario] = 'graziela@lottocap.com.br'
      new_user[:senha] = 1234
      PROD.Login(token, new_user)

      @create = PROD.post_change_user_data(token, build(:change_user_cpf).to_hash)
    end

    it { expect(@create.parsed_response['obj.cpf'][0]).to eql 'O campo cpf contém dados inválidos.' }
  end
end
