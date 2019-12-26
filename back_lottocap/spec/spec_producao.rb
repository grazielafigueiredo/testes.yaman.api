# context 'Pagar 2 produtos no carrinho' do
#     before do
#       @token = ApiUser.GetToken
#       ApiUser.Login(@token, Constant::User1)
  
      
#       ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
#       @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie87, @token)
#       puts @carrinho
#       @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
#       @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
#       puts @result
#     end
    
#     it 'verificando se o carrinho tem 2 produtos para pagamento' do 
#      expect(JSON.parse(@carrinho.response.body)['dadosUsuario']['qtdItensCarrinho']).to be >= 2
#      expect(JSON.parse(@result.response.body)['sucesso']).to be true 
#     end
    
#     after do 
#       ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
#       ApiUser.get_deslogar(@token)
#     end 
#   end

describe 'Criar usuário' do

    # context 'Sucesso' do
    #   before do
    #     @token = ApiUser.GetToken
    #     @create = ApiProducao.post_CadastrarUsuario(@token, Faker::Name.name,Faker::CPF.numeric, Faker::Internet.email)
    #     puts @create
    #   end

    #   it { expect(JSON.parse(@create.response.body)['sucesso']).to be true}

    #   after do
    #     ApiUser.get_deslogar(@token)
    #   end
    # end

    context 'CPF já cadastrado' do
        before do
            @token = ApiUser.GetToken
            @create = ApiProducao.post_CadastrarUsuario(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiUser.GetToken
          @create = ApiProducao.post_CadastrarUsuario(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiUser.GetToken
          @create = ApiProducao.post_CadastrarUsuario(@token, Faker::Name.name, Faker::CPF.numeric, "graziela@lottocap.com.br")
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end
end

describe 'Validador - 1 passo de criação de usuário' do 
    # context 'Sucesso' do
    #     before do
    #       @token = ApiUser.GetToken
    #       @create = ApiProducao.post_ValidarDadosUsuarioCriacao(@token, Faker::Name.name, Faker::CPF.numeric, Faker::Internet.email)
    #     end
  
    #     it { expect(JSON.parse(@create.response.body)['sucesso']).to be true}
  
    #     after do
    #       ApiUser.get_deslogar(@token)
    #     end
    # end

    context 'CPF já cadastrado' do
        before do
            @token = ApiUser.GetToken
            @create = ApiProducao.post_ValidarDadosUsuarioCriacao(@token, Faker::Name.name, "00000009652", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este CPF já está cadastrado. Informe um outro CPF ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'CPF inválido' do
        before do
          @token = ApiUser.GetToken
          @create = ApiProducao.post_ValidarDadosUsuarioCriacao(@token, Faker::Name.name, "00000000000", Faker::Internet.email)
        end
  
        it { expect(JSON.parse(@create.response.body)['obj.CPF'][0]).to eql "O campo CPF contém dados inválidos."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end

    context 'Email já cadastrado' do
        before do
          @token = ApiUser.GetToken
          @create = ApiProducao.post_ValidarDadosUsuarioCriacao(@token, Faker::Name.name, Faker::CPF.numeric, "graziela@lottocap.com.br")
        end
  
        it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Este e-mail já está cadastrado. Informe um outro e-mail ou clique em 'Esqueci a minha senha'."}
  
        after do
          ApiUser.get_deslogar(@token)
        end
    end
end 


describe 'Alterar dados Usuário' do 
#   context 'Sucesso' do
#     before do
#       @token = ApiUser.GetToken
#       ApiUser.Login(@token, Constant::User1)
#       puts @token

#       @create = ApiProducao.post_AlterarDadosUsuario(@token, "user22@gmail.com", "44302702010")
#       puts @create
#     end 

#     it { expect(JSON.parse(@create.response.body)['sucesso']).to be true}
#   end
#   after do
#     ApiUser.get_deslogar(@token)
#   end

  context 'Alterar e-mail para um e-mail já existente no banco de dados' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @create = ApiProducao.post_AlterarDadosUsuario(@token, "user1@gmail.com", "00000000000")
      puts @create
    end 

    it { expect(JSON.parse(@create.response.body)['erros'][0]['mensagem']).to eql "Não foi possível atualizar seus dados, tente novamente se o erro persistir entre em contato conosco"}
  end
  after do
    ApiUser.get_deslogar(@token)
  end

  context 'Alterar cpf para número inválido' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @create = ApiProducao.post_AlterarDadosUsuario(@token, "graziela@lottocap.com.br", "00000000000")
      puts @create
    end 

    it { expect(JSON.parse(@create.response.body)['obj.cpf'][0]).to eql "O campo cpf contém dados inválidos."}
  end
  after do
    ApiUser.get_deslogar(@token)
  end

  context 'Alterar CPF' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @create = ApiProducao.post_AlterarDadosUsuario(@token, "graziela@lottocap.com.br", "44302702010", )
      puts @create
    end 

    it { expect(JSON.parse(@create.response.body)['obj.cpf'][0]).to eql "O campo cpf contém dados inválidos."}
  end
  after do
    ApiUser.get_deslogar(@token)
  end
end