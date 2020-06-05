# frozen_string_literal: true

context 'Criar usuário para rodar nos testes' do
  before do
    User.new.delete_user_email('user22@gmail.com')

    @result = ApiCreateUser.post_create_new_user(build(:user_create).to_hash)

    @token = ApiUser.GetToken
    login = ApiUser.Login(@token, build(:login).to_hash)
    idUsuario = login.parsed_response['obj'][0]['idUsuario']

    User.new.insert_first_access_user(idUsuario)
  end

  it { expect(@result.parsed_response['sucesso']).to be true }
end
