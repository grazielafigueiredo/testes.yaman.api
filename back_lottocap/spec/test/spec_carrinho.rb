# frozen_string_literal: true

describe 'Carrinho - Reserva' do
  dataVencida = '2018-12-25'
  dataVincenda = '2020-12-25'

  # context 'Atualizar carrinho com a quantidade disponível para compra' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, build(:login).to_hash)

  #     @titulo_nao_reservados = CartDB.new.get_titulos_reservados(0, Constant::IdSerieMaxRegular)

  #     CartDB.new.disponibiliza_titulos(@titulo_nao_reservados)

  #     puts bla
  #     CartDB.new.update_maxReservados(1, Constant::IdSerieMaxRegular)

  #     @cart = build(:cart).to_hash
  #     @cart[:qtdItens] = 1
  #     @carrinho = ApiCart.post_add_item_cart(@token, @cart)
  #     @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']
  #     @nomeProduto = @carrinho.parsed_response['obj'][0]['nomeProduto']
  #     @descricaoSerie = @carrinho.parsed_response['obj'][0]['descricaoSerie']

  #     @result = ApiCart.get_status_cart(@token)
  #     puts @result
  #   end

  #   it 'Atualizar carrinho com a quantidade disponível para compra' do
  #     expect(@result.parsed_response['erros'][0]['mensagem']).to eql "A quantidade de títulos que você deseja para o #{@nomeProduto} - #{@descricaoSerie} não está mais disponível. Atualizamos seu carrinho com a quantidade disponível!"
  #   end

  #   after do
  #     CartDB.new.disponibiliza_titulos(@titulo_nao_reservados)
  #     ApiUser.get_logout(@token)
  #   end
  # end

  context 'Carrinho com série indisponível para venda, então deve atualizar com a série nova em andamentoo' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)

      CartDB.new.update_dataFinalVendaVigente(dataVencida)
      @result = ApiCart.get_status_cart(@token)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Atualizamos o carrinho mantendo apenas as série em andamento' }

    after do
      CartDB.new.update_dataFinalVendaVigente(dataVincenda)
      ApiUser.get_logout(@token)
    end
  end

  context 'Validar se o carrinho comporta 2 produtos diferentes' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)

      @cart = build(:cart).to_hash
      @cart[:idSerie] = Constant::IdSerieJa17
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it 'Validar se o carrinho comporta 2 produtos diferentes' do
      expect(@carrinho.parsed_response['obj'][0]['idCarrinho']).to be_a Integer
      expect(@carrinho.parsed_response['obj'][1]['idCarrinho']).to be_a Integer
    end

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Validar se vigência do produto tem data diferente de "0001-01-01T00:00:00"' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']
      @dtFimConcurso = @carrinho.parsed_response['obj'][0]['dtFimConcurso']
    end
    it { expect(@dtFimConcurso).not_to be '0001-01-01T00:00:00' }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Colocar no carrinho quantidade acima permitida ' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @carrinho = ApiCart.post_set_qtd_item_carrinho(@token)
    end

    it { expect(@carrinho.parsed_response['erros'][0]['mensagem']).to eql 'Quantidade limite de titulos para compra atingida!' }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Validar quando não existe nenhum produto disponível na vitrine' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      vitrine_itens = ApiCart.get_product_vitrine(@token)
      @products = vitrine_itens.parsed_response['obj'].map { |obj| obj['idSerie'] }

      cart = build(:cart).to_hash
      ApiCart.post_add_item_cart(@token, cart)
      @products.each { |id_serie| CartDB.new.update_products_vitrine('2018-12-25', id_serie) }

      result = ApiCart.get_status_cart(@token)
      @error_message = result.parsed_response['erros'][0]['mensagem']
    end

    it { expect(@error_message).to eql 'Atualizamos o carrinho mantendo apenas as série em andamento' }

    after do
      @products.each { |id_serie| CartDB.new.update_products_vitrine('2020-12-25', id_serie) }
      ApiUser.get_logout(@token)
    end
  end

  context '[/Pagamento] Tentar pagar uma série fora data vigente com cartão de crédito' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredCVV] = '112399999999'
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.' }

    after do
      CartDB.new.update_dataFinalVendaVigente(dataVincenda)
      ApiUser.get_logout(@token)
    end
  end

  context '[/Pagamento] Tentar pagar uma série fora data vigente com Transferencia' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)

      @payment_transfer = build(:transfer_bradesco).to_hash
      @result = ApiTransfer.post_transfer(@token, @idCarrinho, @payment_transfer)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.' }

    after do
      CartDB.new.update_dataFinalVendaVigente(dataVincenda)
      ApiUser.get_logout(@token)
    end
  end

  context '[/Pagamento] Tentar pagar uma série fora data vigente com Boleto' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)

      @payment_boleto = build(:boleto).to_hash
      @result = ApiBoleto.post_payment_cart_boleto(@token, @idCarrinho, @payment_boleto)
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.' }

    after do
      CartDB.new.update_dataFinalVendaVigente(dataVincenda)
      ApiUser.get_logout(@token)
    end
  end

  context '[/Pagamento] Tentar pagar uma série fora data vigente com Crédito Lottocap' do
    before do
      @token = ApiUser.GetToken
      login = ApiUser.Login(@token, build(:login).to_hash)
      @idUsuario = login.parsed_response['obj'][0]['idUsuario']

      CreditoLotto.new.update_creditoLottocap(100, @idUsuario)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)

      @credit = build(:payment_credit).to_hash
      @payment_credit = ApiCreditoLottocap.post_payment_credit_lottocap(@token, @idCarrinho, @credit)
    end

    it { expect(@payment_credit.parsed_response['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.' }

    after do
      CartDB.new.update_dataFinalVendaVigente(dataVincenda)
      CreditoLotto.new.update_creditoLottocap(100, @idUsuario)
      ApiUser.get_logout(@token)
    end
  end

  context '[/Pagamento] Adicionar no carrinho uma série vigente, mas no pagamento ela deve ficar fora de vigência, então deve impedir o pagamento' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      CartDB.new.update_dataFinalVendaVigente(dataVencida)

      @payment_boleto = build(:boleto).to_hash
      @result = ApiBoleto.post_payment_cart_boleto(@token, @idCarrinho, @payment_boleto)
      puts @result
    end

    it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.' }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context '[/Pagamento] Validar se no carrinho não ficou nenhum cache da última compra' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']
      puts carrinho
      credit_card = build(:credit_card).to_hash
      v = ApiCartao.post_credit_card(@token, idCarrinho, credit_card)
      puts v
      @result = ApiCart.post_cart_itens(@token)
    end

    it { expect(@result.parsed_response['obj']).to eql [] }

    after do
      ApiUser.get_logout(@token)
    end
  end

  # TESTE COM TIMEOUT

  # context '[/Pagamento] No momento do pagamento a quantidade total de títulos não está mais disponível, então deve impedir o pagamento' do
  #   before do
  #     @token = ApiUser.GetToken
  #     ApiUser.Login(@token, build(:login).to_hash)

  #     @cart = build(:cart).to_hash
  #     @cart[:qtdItens] = 300
  #     @carrinho = ApiCart.post_add_item_cart(@token, @cart)
  #     puts @carrinho
  #     @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

  #     @payment_boleto = build(:boleto).to_hash
  #     @result = ApiBoleto.post_payment_cart_boleto(@token, @idCarrinho, @payment_boleto)
  #     puts @result
  #   end

  #   it { expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Não foi possível Reservar os Titulos Solicitados!' }

  #   after do
  #     ApiUser.get_logout(@token)
  #   end
  # end

  context 'Limpar carrinho quando o usuário já logado navegar pelo endpoint /afiliados' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      cart = build(:cart).to_hash
      ApiCart.post_add_item_cart(@token, cart)

      cart_afiliados = build(:cart_afiliados).to_hash
      @carrinho = ApiCart.post_add_item_cart_afiliados(@token, cart_afiliados)
    end

    it 'Verificar se existe apenas 1 produto no carrinho, e se é um Lottocap Já 17' do
      expect(@carrinho.parsed_response['obj'][0]['nomeProduto']).to eql 'LottoCap Já 17'
      expect(@carrinho.parsed_response['obj'].count).to eq(1)
    end

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Limpar produtos no carrinho quando o cliente vier pela endpoint de Afiliados -  usuário deslogado, add produto no carrinho e depois loga, e passar pelo endpoint de afilados, entao deve limpar carrinho' do
    before do
      @token = ApiUser.GetToken

      cart = build(:cart).to_hash
      ApiCart.post_add_item_cart(@token, cart)

      ApiUser.Login(@token, build(:login).to_hash)

      cart_afiliados = build(:cart_afiliados).to_hash
      @carrinho = ApiCart.post_add_item_cart_afiliados(@token, cart_afiliados)
    end

    it 'Verificar se existe apenas 1 produto no carrinho, e se é um Lottocap Já 17' do
      expect(@carrinho.parsed_response['obj'][0]['nomeProduto']).to eql 'LottoCap Já 17'
      expect(@carrinho.parsed_response['obj'].count).to eq(1)
    end

    after do
      ApiUser.get_logout(@token)
    end
  end
end
