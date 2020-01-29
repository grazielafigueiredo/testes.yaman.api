# frozen_string_literal: true

describe 'Carrinho - Reserva' do
  context 'Quantidade parcialmente indisponível' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)

      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(3000000, Constant::IdProduto, Constant::IdSerie, @token)
        # @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
        @idCarrinho = JSON.parse(@carrinho.response.body)['dadosUsuario']['carrinhoItens'][0]['idCarrinho']
        @nomeProduto = JSON.parse(@carrinho.response.body)['dadosUsuario']['carrinhoItens'][0]['nomeProduto']
        @descricaoSerie = JSON.parse(@carrinho.response.body)['dadosUsuario']['carrinhoItens'][0]['descricaoSerie']
      @result = ApiCarrinho.get_GetStatusCarrinho
      puts @carrinho
    end

    it 'Quantidade parcialmente indisponível' do
      expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "A quantidade de títulos que você deseja para o #{@nomeProduto} - #{@descricaoSerie} não está mais disponível. Atualizamos seu carrinho com a quantidade disponível!"
    end

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
  context 'Atualizar carrinho com outra série em andamento' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)

      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_DataFinalVendaVigente('2018-12-25')
      @result = ApiCarrinho.get_GetStatusCarrinho
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Atualizamos o carrinho mantendo apenas as série em andamento' }

    after do
      Database.new.update_DataFinalVendaVigente('2020-12-25')
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Pagar 2 produtos no carrinho' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)

      ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie87, @token)
      puts @carrinho
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
      puts @result
    end

    it 'verificando se o carrinho tem 2 produtos para pagamento' do
     expect(JSON.parse(@carrinho.response.body)['dadosUsuario']['qtdItensCarrinho']).to be >= 2
     expect(JSON.parse(@result.response.body)['sucesso']).to be true
    end

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end

  context 'Quando o produto estiver na vigência' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)

      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCarrinho.get_GetStatusCarrinho
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['dadosUsuario']['carrinhoItens'][0]['dtFimConcurso']).to eql '0001-01-01T00:00:00' }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end

  # context 'Enviar quantidade acima de 299 para pagamento' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)

  #     # ApiCarrinho.post_AdicionarItemCarrinho(300, Constant::IdProduto, Constant::IdSerie, @token)
  #     @carrinho = ApiCarrinho.post_SetQtdItemCarrinho(300, @token, Constant::IdSerie)
  #     puts @carrinho
  #   end

  #   it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql 'Quantidade limite de titulos para compra atingida!' }

  #   after do 
  #     ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
  #     ApiUser.get_deslogar(@token)
  #   end 
  # end

  context 'Nenhum produto na vitrine' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)

      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(300, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_TodosProdutosIndisponiveisVitrine('2018-12-25')

      @result = ApiCarrinho.get_GetStatusCarrinho
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Atualizamos o carrinho mantendo apenas as série em andamento' }

    after do
      Database.new.update_TodosProdutosIndisponiveisVitrine('2020-12-25')
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
  # TESTE COM TIMEOUT
  context 'Quantidade total indisponível ' do
    before do
      @token = ApiUser.GetToken
        ApiUser.Login(@token, Constant::User1)

        Database.new.update_DataFinalVendaVigente('2020-12-25')
        Database.new.update_MaxReservados(0)

      @result = ApiCarrinho.post_AdicionarItemCarrinho(500, Constant::IdProduto, Constant::IdSerie, @token)
      puts @result
        @idCarrinho = JSON.parse(@result.response.body)['obj'][0]['idCarrinho']
        # @idCarrinho = JSON.parse(@result.response.body)['dadosUsuario']['carrinhoItens'][0]['idCarrinho']
        @nomeProduto = JSON.parse(@result.response.body)['dadosUsuario']['carrinhoItens'][0]['nomeProduto']
        @descricaoSerie = JSON.parse(@result.response.body)['dadosUsuario']['carrinhoItens'][0]['descricaoSerie']

      Database.new.update_MaxNaVitrine('2018-12-25')
      Database.new.update_MaxReservados(1)

      @carrinho = ApiCarrinho.get_GetStatusCarrinho
    end

    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Não há mais títulos disponíveis para o #{@nomeProduto} - #{@descricaoSerie}. Tente adicionar um novo produto ao carrinho."}
    # it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Não há mais títulos disponíveis para o LottoCap Max - Max Série Nova (id 86). Tente adicionar um novo produto ao carrinho."}

    after do
      Database.new.update_MaxNaVitrine('2020-12-25')
      Database.new.update_MaxReservados(0)

      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end

describe 'Carrinho - Sem Reserva - Tentar Pagar' do
  context 'série indisponível com Cartão de Crédito ' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)

      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
        @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_DataFinalVendaVigente('2018-12-25')

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente('2020-12-25')
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Tentar pagar série indisponível com Transferencia' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)

      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
        @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_DataFinalVendaVigente('2018-12-25')

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), Constant::NomeCompletoTitular)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente('2020-12-25')
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Tentar pagar série indisponível com Boleto' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)

      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
        @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_DataFinalVendaVigente('2018-12-25')

      @result = ApiBoleto.post_SucessoBoleto(@token, @idCarrinho)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente('2020-12-25')
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'série indisponível com Crédito Lottocap' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)
      Database.new.update_CreditoLottocap(100.000)

      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
        @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_DataFinalVendaVigente('2018-12-25')

      @result = ApiCreditoLottocap.post_CreditoLottocap(@token, @idCarrinho)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_CreditoLottocap(0.000)

      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Atualizar carrinho com outra série em andamento' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)

      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
        @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_DataFinalVendaVigente('2018-12-25')

      @result = ApiBoleto.post_SucessoBoleto(@token, @idCarrinho)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente('2020-12-25')
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Cache no carrinho, após confirmação de compra' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)

      ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie87, @token)
        @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_DataFinalVendaVigente('2018-12-25')
      @resultGetCarrinho = ApiCarrinho.get_GetStatusCarrinho
      puts @resultGetCarrinho

      ApiCarrinho.post_GetCarrinhoItens(@token)
      ApiCartao.post_ObterFormasPagamentoDisponiveis(@token, @idCarrinho)
      ApiCarrinho.get_GetStatusCarrinho
      ApiCartao.post_ObterFormasPagamentoDisponiveis(@token, @idCarrinho)
      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
      # puts @result
    end

    it 'j' do
      expect(JSON.parse(@resultGetCarrinho.response.body)['erros'][0]['mensagem']).to eql "Atualizamos o carrinho mantendo apenas as série em andamento"
    end
    after do
      Database.new.update_DataFinalVendaVigente('2020-12-25')
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

    # TESTE COM TIMEOUT

  # context 'Quantidade parcialmente indisponível' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)

  #     @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(300, Constant::IdProduto, Constant::IdSerie, @token)
  #     @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
  #     puts @carrinho
  #     @result = ApiBoleto.post_SucessoBoleto(@token, @idCarrinho)
  #     puts @result
  #   end

  #   it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Não foi possível Reservar os Titulos Solicitados!"}
    
  #   after do
  #     ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
  #     ApiUser.get_deslogar(@token)
  #   end
  # end

  context 'Limpar produtos no carrinho quando o cliente vier pela endpoint de Afiliados -  usuário logado' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      Database.new.update_DataFinalVendaVigente('2020-12-25')
      Database.new.update_MaxReservados(0)

      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(5, Constant::IdProduto, Constant::IdSerie, @token)
        @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
      # puts @carrinho
      puts @token

      @endpointAfiliados = ApiCarrinho.post_AdicionarItemCarrinhoAfiliados(@token, Constant::IdProduto, Constant::IdSerie87, 2)
      # puts @endpointAfiliados
      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
      puts @result
    end

    it 'validando série e quantidade de itens no carrinho' do
      expect(JSON.parse(@endpointAfiliados.response.body)['dadosUsuario']['carrinhoItens'][0]['descricaoSerie']).to eql "Max Série Nova (id 87)"
      expect(JSON.parse(@endpointAfiliados.response.body)['dadosUsuario']['carrinhoItens'][0]['quantidade']).to be 2
    end

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Limpar produtos no carrinho quando o cliente vier pela endpoint de Afiliados -  usuário deslogado, add produto no carrinho e depois loga, e passar pelo endpoint de afilados, entao deve limpar carrinho' do
    before do
      @token = ApiUser.GetToken

      @carrinho = ApiCarrinho.post_AdicionarItemCarrinho(5, Constant::IdProduto, Constant::IdSerie, @token)
        @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
        puts @carrinho 

      ApiUser.Login(@token, Constant::User1)

      @endpointAfiliados = ApiCarrinho.post_AdicionarItemCarrinhoAfiliados(@token, Constant::IdProduto, Constant::IdSerie87, 2)
      puts @endpointAfiliados
      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
      puts @result
    end

    it 'validando série e quantidade de itens no carrinho' do
       expect(JSON.parse(@endpointAfiliados.response.body)['dadosUsuario']['carrinhoItens'][0]['descricaoSerie']).to eql "Max Série Nova (id 87)"
       expect(JSON.parse(@endpointAfiliados.response.body)['dadosUsuario']['carrinhoItens'][0]['quantidade']).to be 2
    end

    after do
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end
