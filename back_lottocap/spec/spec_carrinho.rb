# frozen_string_literal: true

# login


describe 'Carrinho - Reserva' do

  context 'Verificar que a quantidade de produto no carrinho é maior que > 0' do
    before do
      @result = ApiCarrinho.post_AdicionarItemCarrinho(1)
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['dadosUsuario']['carrinhoItens'][0]['quantidade']).to be > 0 }
  end
  
  context 'Quando o produto estiver na vigência' do
    before do
      ApiCarrinho.post_AdicionarItemCarrinho(1)
      @result = ApiCarrinho.get_GetStatusCarrinho
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['dadosUsuario']['carrinhoItens'][0]['dtFimConcurso']).to eql '0001-01-01T00:00:00' }
  end

  context 'Enviar quantidade além da permitida' do
    before do
      @carrinho = ApiCarrinho.get_GetStatusCarrinho
      @result = ApiCarrinho.post_SetQtdItemCarrinho(20000)
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Quantidade limite de titulos para compra atingida!' }
  end

  context 'Atualizar carrinho com outra série em andamento' do
    before do
      @result = ApiCarrinho.post_AdicionarItemCarrinho(1)

      Database.new.update_AtualizarSerieAndamento

      @carrinho = ApiCarrinho.get_GetStatusCarrinho
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql 'Atualizamos o carrinho mantendo apenas as série em andamento' }

    after do
      Database.new.update_DataFinalVendaVigente
    end
  end

  context 'Quantidade parcialmente indisponível' do
    before do
      @result = ApiCarrinho.post_AdicionarItemCarrinho(3000000)
      @carrinho = ApiCarrinho.get_GetStatusCarrinho
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql 'A quantidade de títulos que você deseja para o LottoCap Max - Max Série Nova (id 86) não está mais disponível. Atualizamos seu carrinho com a quantidade disponível!' }

  end

  context 'Nenhum produto na vitrine' do
    before do
      @result = ApiCarrinho.post_AdicionarItemCarrinho(1)

      Database.new.update_TodosProdutosIndisponiveisVitrine

      @carrinho = ApiCarrinho.get_GetStatusCarrinho
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql 'Atualizamos o carrinho mantendo apenas as série em andamento' }

    after do
      Database.new.update_VendaFinalDisponiveisVitrine
    end
  end

  # context 'Remover item do carrinho' do
  #   before do
  #     @result = ApiCarrinho.post_SetRemoverItemCarrinho(1)
  #   end
  #   it { expect(@result.response.code).to eql '200' }
  #   it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
  # end

  # context 'Quantidade total indisponível ' do
  #   before do
  #     @result = ApiCarrinho.post_AdicionarItemCarrinho(1000)

  #     Database.new.update_MaxIndisponiveisVitrine
  #     Database.new.update_MaxReservadosIndisponiveis
  #     sleep(20)


  #     @carrinho = ApiCarrinho.get_GetStatusCarrinho
  #   end

  #   it { expect(@result.response.code).to eql '200' }
  #   it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql 'Não há mais títulos disponíveis para o LottoCap Max - Max Série Nova (id 86). Tente adicionar um novo produto ao carrinho.' }

  #   after do
  #     Database.new.update_MaxReservadosDisponiveis 
  #     Database.new.update_VendaFinalDisponiveisVitrine
  #     sleep(20)

  #   end
  # end
end

describe 'Carrinho - Sem Reserva - Tentar Pagar' do
  context 'Tentar pagar série indisponível com Cartão de Crédito ' do
    before do
      @result = ApiCarrinho.post_AdicionarItemCarrinho(1)

      Database.new.update_AtualizarSerieAndamento

      @carrinho = ApiPagamento.post_AdicionarCartaoDeCreditoSucesso
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente
    end
  end

  context 'Tentar pagar série indisponível com Transferencia' do
    before do
      @result = ApiCarrinho.post_AdicionarItemCarrinho(1)

      Database.new.update_AtualizarSerieAndamento

      @carrinho = ApiTransferencia.post_TransfSucessoBradesco
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente
    end
  end

  context 'Tentar pagar série indisponível com Boleto' do
    before do
      @result = ApiCarrinho.post_AdicionarItemCarrinho(1)

      Database.new.update_AtualizarSerieAndamento

      @carrinho = ApiBoleto.post_SucessoBoleto
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente
    end
  end

  context 'Tentar pagar série indisponível com Crédito Lottocap' do
    before do
      @result = ApiCarrinho.post_AdicionarItemCarrinho(1)

      Database.new.update_AtualizarSerieAndamento

      @carrinho = ApiCreditoLottocap.post_SucessoCreditoLottocap
    end

    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento."}

    after do
      Database.new.update_DataFinalVendaVigente
    end
  end
end  
