# frozen_string_literal: true

describe 'Carrinho - Reserva' do

  context 'Pagar 2 produtos no carrinho' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      
      ApiCarrinho.post_AdicionarItemCarrinho(1, @token)
      @result = ApiCarrinho.post_AdicionarItemCarrinho87(1, @token)

      @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']
      
      @carrinho = ApiCartao.post_AdicionarCartaoDeCreditoSucesso(@token, @idCarrinho)
    end
    
    it { expect(JSON.parse(@result.response.body)['dadosUsuario']['qtdItensCarrinho']).to be >= 2}
    it { expect(JSON.parse(@carrinho.response.body)['sucesso']).to be true }
    
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end

  context 'Quando o produto estiver na vigência' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, @token)
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCarrinho.get_GetStatusCarrinho
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['dadosUsuario']['carrinhoItens'][0]['dtFimConcurso']).to eql '0001-01-01T00:00:00' }
  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end

  # context 'Enviar quantidade além da permitida' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)
  
  #     @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(3000000, @token)
  #     @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
  #     @result = ApiCarrinho.get_GetStatusCarrinho
  #   end

  #   it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Quantidade limite de titulos para compra atingida!' }

  #   after do 
  #     ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
  #     ApiUser.get_deslogar(@token)
  #   end 
  # end

  context 'Atualizar carrinho com outra série em andamento' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      @result = ApiCarrinho.post_AdicionarItemCarrinho(1, @token)
      @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']
      
      Database.new.update_AtualizarSerieAndamento

      @carrinho = ApiCarrinho.get_GetStatusCarrinho
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql 'Atualizamos o carrinho mantendo apenas as série em andamento' }

    after do
      Database.new.update_DataFinalVendaVigente
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Quantidade parcialmente indisponível' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      @result = ApiCarrinho.post_AdicionarItemCarrinho(3000000, @token)
      @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']
      @carrinho = ApiCarrinho.get_GetStatusCarrinho
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql 'A quantidade de títulos que você deseja para o LottoCap Max - Max Série Nova (id 86) não está mais disponível. Atualizamos seu carrinho com a quantidade disponível!' }
   
    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Nenhum produto na vitrine' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      @result = ApiCarrinho.post_AdicionarItemCarrinho(300, @token)
      @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']

      Database.new.update_TodosProdutosIndisponiveisVitrine
      sleep 2

      @carrinho = ApiCarrinho.get_GetStatusCarrinho
    end

    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql 'Atualizamos o carrinho mantendo apenas as série em andamento' }

    after do
      Database.new.update_VendaFinalDisponiveisVitrine
      sleep 2
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  # context 'Quantidade total indisponível ' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)
  
  #     @result = ApiCarrinho.post_AdicionarItemCarrinho(1000, @token)
  #     @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']

  #     Database.new.update_MaxIndisponiveisVitrine
  #     sleep 2
  #     Database.new.update_MaxReservadosIndisponiveis
  #     sleep 5

  #     @carrinho = ApiCarrinho.get_GetStatusCarrinho
  #   end

  #   it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql 'Não há mais títulos disponíveis para o "#{Constant::Produto}". Tente adicionar um novo produto ao carrinho.' }

  #   after do
  #     Database.new.update_MaxReservadosDisponiveis 
  #     sleep 10
  #     Database.new.update_VendaFinalDisponiveisVitrine
  #     sleep 2
  #     ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
  #     ApiUser.get_deslogar(@token)
  #   end
  # end
end

describe 'Carrinho - Sem Reserva - Tentar Pagar' do
  context 'Tentar pagar série indisponível com Cartão de Crédito ' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiCarrinho.post_AdicionarItemCarrinho(1, @token)
      @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']

      Database.new.update_AtualizarSerieAndamento

      @carrinho = ApiCartao.post_AdicionarCartaoDeCreditoSucesso(@token, @idCarrinho)
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Tentar pagar série indisponível com Transferencia' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiCarrinho.post_AdicionarItemCarrinho(1, @token)
      @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']

      Database.new.update_AtualizarSerieAndamento

      @carrinho = ApiTransferencia.post_TransfSucessoBradesco(@token, @idCarrinho)
    end

    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Tentar pagar série indisponível com Boleto' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @result = ApiCarrinho.post_AdicionarItemCarrinho(1, @token)
      @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']

      Database.new.update_AtualizarSerieAndamento

      @carrinho = ApiBoleto.post_SucessoBoleto(@token, @idCarrinho)
    end

    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Tentar pagar série indisponível com Crédito Lottocap' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_insertCreditoLottocap

      @result = ApiCarrinho.post_AdicionarItemCarrinho(1, @token)
      @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']

      Database.new.update_AtualizarSerieAndamento

      @carrinho = ApiCreditoLottocap.post_SucessoCreditoLottocap(@token, @idCarrinho)
    end

    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}
  
    after do
      Database.new.update_DataFinalVendaVigente
      Database.new.update_deleteCreditoLottocap
  
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
  

  context 'Atualizar carrinho com outra série em andamento' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      
      @result = ApiCarrinho.post_AdicionarItemCarrinho(1, @token)
      @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']
      
      Database.new.update_AtualizarSerieAndamento
      
      @carrinho = ApiBoleto.post_SucessoBoleto(@token, @idCarrinho)
      
    end
    
    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  # context 'Quantidade parcialmente indisponível' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)

  #     @result = ApiCarrinho.post_AdicionarItemCarrinho(3000000, @token)
  #     @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']

  #     @carrinho = ApiBoleto.post_SucessoBoleto(@token, @idCarrinho)
  #   end

  #   it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Não foi possível Reservar os Titulos Solicitados!"}
  #   it {puts @carrinho.response.body}
  #   after do
  #     ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
  #     ApiUser.get_deslogar(@token)
  #   end
  # end
end  
