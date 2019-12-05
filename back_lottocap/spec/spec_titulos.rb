# frozen_string_literal: true

describe 'Títulos' do
  context 'Agrupador por série' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_BuscarTitulosAgrupadosPorSerie(@token)
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Títulos novos' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_GetTitulosNovos(@token)
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end


describe 'Verificar Premio Titulo' do
  context 'Sucesso' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_VerificarPremioTitulo(@token, Constant::IdTitulo)
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true}
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Título outro usuário' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_VerificarPremioTitulo(@token, 89)
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Este título não pertence ao usuário!" }
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  # context 'Título Null' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)

  #     @result = ApiTitulos.post_VerificarPremioTitulo(@token, nil)
  #   end

  #   it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "Unexpected character encountered while parsing value: }. Path 'obj.idTitulo', line 4, position 2."}
  #   it { puts @result.response.body }

  #   after do
  #     ApiUser.get_deslogar(@token)
  #   end
  # end

  context 'Título ID passando maior de 10 inteiros' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_VerificarPremioTitulo(@token, 12345678901)
    end

    it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "JSON integer 12345678901 is too large or small for an Int32. Path 'obj.idTitulo', line 1, position 30."}
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end



describe 'Abrir Título' do

  context 'Sucesso' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_AbrirTitulo(@token, Constant::IdTitulo)
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true}
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Título outro usuário' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_AbrirTitulo(@token, 89)
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Título não pertence ao usuário!" }
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end

  # context 'Título Null' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)

  #     @result = ApiTitulos.post_AbrirTitulo(@token, nil)
  #   end

  #   it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "Unexpected character encountered while parsing value: }. Path 'obj.idTitulo', line 4, position 2."}
  #   it { puts @result.response.body }

  #   after do
  #     ApiUser.get_deslogar(@token)
  #   end
  # end

  context 'Título ID passando maior de 10 inteiros' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_AbrirTitulo(@token, 12345678901)
    end

    it { expect(JSON.parse(@result.response.body)['obj.idTitulo'][0]).to eql "JSON integer 12345678901 is too large or small for an Int32. Path 'obj.idTitulo', line 1, position 30."}
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'BuscarTitulosNaoAbertosUsuario' do
  context 'Sucesso' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_BuscarTitulosNaoAbertosUsuario(@token)
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'GetMultiplicador' do
  context 'Sucesso' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiTitulos.post_GetMultiplicador(@token)
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { puts @result.response.body }

    after do
      ApiUser.get_deslogar(@token)
    end
  end
end
