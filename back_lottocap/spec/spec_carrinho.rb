# frozen_string_literal: true

describe 'Carrinho - Reserva' do
  reservado = 1
  naoReservado = 0
  dataVencida = '2018-12-25'
  CartDB.new.update_dataFinalVendaVigente('2020-12-25')

  context 'Atualizar carrinho com a quantidade disponível para compra' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      # CartDB.new.update_maxReservados(naoReservado)
      @cart = build(:cart).to_hash
      @cart[:qtdItens] = 3_000_000
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']
      @nomeProduto = @carrinho.parsed_response['obj'][0]['nomeProduto']
      @descricaoSerie = @carrinho.parsed_response['obj'][0]['descricaoSerie']

      @result = ApiCart.get_GetStatusCarrinho
      puts @result
    end

    it 'Atualizar carrinho com a quantidade disponível para compra' do
      expect(@result.parsed_response['erros'][0]['mensagem']).to eql "A quantidade de títulos que você deseja para o #{@nomeProduto} - #{@descricaoSerie} não está mais disponível. Atualizamos seu carrinho com a quantidade disponível!"
    end

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context 'Carrinho com série indisponível para venda, então deve atualizar com a série nova em andamentoo' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      # CartDB.new.update_maxReservados(naoReservado)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)
      @result = ApiCart.get_GetStatusCarrinho
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Atualizamos o carrinho mantendo apenas as série em andamento' }

    after do
      CartDB.new.update_dataFinalVendaVigente(dataVincenda)
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context 'Validar se o carrinho comporta 2 produtos diferentes' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      # CartDB.new.update_maxReservados(naoReservado)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @cart = build(:cart).to_hash
      @cart[:idSerie] = Constant::IdSerieJa17
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)

      puts @result
    end

    it 'Validar se o carrinho comporta 2 produtos diferentes' do
      expect(JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']).to be_a Integer
      expect(JSON.parse(@carrinho.response.body)['obj'][1]['idCarrinho']).to be_a Integer
    end

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context 'Validar se vigência do produto tem data diferente de "0001-01-01T00:00:00"' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      # CartDB.new.update_maxReservados(naoReservado)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']
      @dtFimConcurso = @carrinho.parsed_response['obj'][0]['dtFimConcurso']
    end
    it { expect(@dtFimConcurso).not_to be '0001-01-01T00:00:00' }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  # context 'Colocar no carrinho quantidade acima permitida ' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, Constant::User1)

  #     # ApiCart.post_adicionarItemCarrinho(300, Constant::IdProduto, Constant::IdSerieMaxRegular, @token)
  #     @carrinho = ApiCart.post_SetQtdItemCarrinho(300, @token, Constant::IdSerieMaxRegular)
  #     puts @carrinho
  #   end

  #   it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql 'Quantidade limite de titulos para compra atingida!' }

  #   after do
  #     ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
  #     ApiUser.get_logout(@token)
  #   end
  # end

  context 'Validar quando não existe nenhum produto disponível na vitrine' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      # CartDB.new.update_maxReservados(naoReservado)

      @cart = build(:cart).to_hash
      @cart[:qtdItens] = 300
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      Database.new.update_TodosProdutosIndisponiveisVitrine('2018-12-25')

      @result = ApiCart.get_GetStatusCarrinho
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Atualizamos o carrinho mantendo apenas as série em andamento' }

    after do
      Database.new.update_TodosProdutosIndisponiveisVitrine('2020-12-25')
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end
  # TESTE COM TIMEOUT
  context 'Produto não está mais disponível, então deve indicar outro produto para comprar' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      # CartDB.new.update_maxReservados(naoReservado)

      @cart = build(:cart).to_hash
      @cart[:qtdItens] = 500
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']
      @nomeProduto = JSON.parse(@result.response.body)['obj'][0]['nomeProduto']
      @descricaoSerie = JSON.parse(@result.response.body)['obj'][0]['descricaoSerie']

      CartDB.new.update_maxNaVitrine(dataVencida)
      CartDB.new.get_titulos_reservados
      # CartDB.new.update_maxReservados(reservado)

      @carrinho = ApiCart.get_GetStatusCarrinho
      puts @carrinho
    end

    it { expect(JSON.parse(@carrinho.response.body)['erros'][0]['mensagem']).to eql "Não há mais títulos disponíveis para o #{@nomeProduto} - #{@descricaoSerie}. Tente adicionar um novo produto ao carrinho." }

    after do
      CartDB.new.update_maxNaVitrine(dataVincenda)
      CartDB.new.update_maxReservados(naoReservado)

      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end
end

describe '[/Pagamento] Produtos fora da vigência' do
  reservado = 1
  naoReservado = 0
  dataVencida = '2018-12-25'
  dataVincenda = '2020-12-25'

  context 'Tentar pagar uma série fora data vigente com cartão de crédito' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      # CartDB.new.update_maxReservados(naoReservado)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredCVV] = '112399999999'
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)

      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.' }

    after do
      CartDB.new.update_dataFinalVendaVigente(dataVincenda)
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context 'Tentar pagar uma série fora data vigente com Transferencia' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      # CartDB.new.update_maxReservados(naoReservado)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)

      @result = ApiTransferencia.post_TransfBradesco(@token, @idCarrinho, Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 4), Faker::Bank.account_number(digits: 1), 'CARLOS')
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.' }

    after do
      CartDB.new.update_dataFinalVendaVigente(dataVincenda)
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context 'Tentar pagar uma série fora data vigente com Boleto' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      # CartDB.new.update_maxReservados(naoReservado)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)

      @result = ApiBoleto.post_pagarCarrinhoComBoleto(@token, @idCarrinho)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.' }

    after do
      CartDB.new.update_dataFinalVendaVigente(dataVincenda)
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context 'Tentar pagar uma série fora data vigente com Crédito Lottocap' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      CartDB.new.update_maxReservados(naoReservado)
      CreditoLotto.new.update_creditoLottocap(100.000)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)

      @result = ApiCreditoLottocap.post_pagarCarrinhoComCreditoLottocap(@token, @idCarrinho)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.' }

    after do
      CreditoLotto.new.update_creditoLottocap(0.000)

      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context 'Adicionar no carrinho uma série vigente, mas no pagamento ela fico fora de vigência, então deve impedir o pagamento' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      CartDB.new.update_maxReservados(naoReservado)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)

      @result = ApiBoleto.post_pagarCarrinhoComBoleto(@token, @idCarrinho)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.' }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context 'Validar se no carrinho não ficou nenhum cache da última compra' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      CartDB.new.update_maxReservados(naoReservado)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      # @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @cart = build(:cart).to_hash
      @cart[:idSerie] = Constant::IdSerieMaxPreVenda
      @cart[:idProduto] = Constant::IdProduto
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)

      @resultGetCarrinho = ApiCart.get_GetStatusCarrinho
      puts @resultGetCarrinho

      ApiCart.post_GetCarrinhoItens(@token)
      ApiCartao.post_ObterFormasPagamentoDisponiveis(@token, @idCarrinho)
      ApiCart.get_GetStatusCarrinho
      ApiCartao.post_ObterFormasPagamentoDisponiveis(@token, @idCarrinho)

      @credit_card = build(:credit_card).to_hash
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)

      # puts @result
    end

    it 'Validar se no carrinho não ficou nenhum cache da última compra' do
      expect(JSON.parse(@resultGetCarrinho.response.body)['erros'][0]['mensagem']).to eql 'Atualizamos o carrinho mantendo apenas as série em andamento'
    end
    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  # TESTE COM TIMEOUT

  context 'No momento do pagamento a quantidade total de títulos não está mais disponível, então deve impedir o pagamento' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @cart[:qtdItens] = 300
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']
      puts @carrinho
      @result = ApiBoleto.post_SucessoBoleto(@token, @idCarrinho)
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Não foi possível Reservar os Titulos Solicitados!' }

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context 'Limpar carrinho quando o usuário já logado navegar pelo endpoint /afiliados' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      # CartDB.new.update_maxReservados(naoReservado)

      @cart = build(:cart).to_hash
      @cart[:qtdItens] = 5
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']
      puts @token

      @endpointAfiliados = ApiCart.post_adicionarItemCarrinhoAfiliados(
        @token,
        Constant::IdProduto,
        Constant::IdSerieJa17,
        2
      )

      @credit_card = build(:credit_card).to_hash
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)

      puts @endpointAfiliados
    end

    it 'Limpar carrinho quando o usuário já logado navegar pelo endpoint /afiliados' do
      expect(JSON.parse(@endpointAfiliados.response.body)['obj'][0]['descricaoSerie']).to eql '17test (grazi não me mata - by wes)'
      expect(JSON.parse(@endpointAfiliados.response.body)['obj'][0]['idCarrinho']).to be_a Integer
      expect(JSON.parse(@endpointAfiliados.response.body)['obj'].count).to eq(1)
    end

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end

  context 'Limpar produtos no carrinho quando o cliente vier pela endpoint de Afiliados -  usuário deslogado, add produto no carrinho e depois loga, e passar pelo endpoint de afilados, entao deve limpar carrinho' do
    before do
      @token = ApiUser.GetToken

      @cart = build(:cart).to_hash
      @cart[:qtdItens] = 5
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']
      puts @carrinho

      ApiUser.Login(@token, Constant::User1)

      @endpointAfiliados = ApiCart.post_adicionarItemCarrinhoAfiliados(
        @token,
        Constant::IdProduto,
        Constant::IdSerieJa17,
        2
      )
      puts @endpointAfiliados
      @credit_card = build(:credit_card).to_hash
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)

      puts @result
    end

    it 'Limpar carrinho quando o usuário deslogado navegar pelo endpoint /afiliados' do
      expect(JSON.parse(@endpointAfiliados.response.body)['obj'][0]['descricaoSerie']).to eql '17test (grazi não me mata - by wes)'
      expect(JSON.parse(@endpointAfiliados.response.body)['obj'][0]['idCarrinho']).to be_a Integer
      expect(JSON.parse(@endpointAfiliados.response.body)['obj'].count).to eq(1)
    end

    after do
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end
end
