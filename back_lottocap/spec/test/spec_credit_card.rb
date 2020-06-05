# frozen_string_literal: true

require 'utils/constant'

describe 'Cartão de Crédito' do
  dataVincenda = '2020-12-25'

  context 'validar se todas as formas de pagamento estão disponíveis seguindo regra de valor mínimo para compra' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      @result = ApiCartao.post_ObterFormasPagamentoDisponiveis(@token, idCarrinho)
    end
    it 'validar se todas as formas de pagamento estão disponíveis seguindo regra de valor mínimo para compra' do
      expect((@result.parsed_response)['obj'][0]['formasPai'][0]['tipo']).to eql 'cartao_credito'
      expect((@result.parsed_response)['obj'][0]['formasPai'][0]['nome']).to eql 'Cartão de Crédito'
      expect((@result.parsed_response)['obj'][0]['formasPai'][0]['idFormaPagamento'][0]).to be 1
      expect((@result.parsed_response)['obj'][0]['formasPai'][0]['vlMinimo']).to be >= 5.0

      expect((@result.parsed_response)['obj'][0]['formasPai'][1]['tipo']).to eql 'transf_bancaria'
      expect((@result.parsed_response)['obj'][0]['formasPai'][1]['idFormaPagamento']).to be 2
      expect((@result.parsed_response)['obj'][0]['formasPai'][1]['vlMinimo']).to be >= 5.0

      expect((@result.parsed_response)['obj'][0]['formasPai'][2]['tipo']).to eql 'boleto'
      expect((@result.parsed_response)['obj'][0]['formasPai'][2]['idFormaPagamento']).to be 3
      expect((@result.parsed_response)['obj'][0]['formasPai'][2]['vlMinimo']).to be >= 20.0

      expect((@result.parsed_response)['obj'][0]['formasPai'][3]['tipo']).to eql 'credito'
      expect((@result.parsed_response)['obj'][0]['formasPai'][3]['idFormaPagamento']).to be 4
      expect((@result.parsed_response)['obj'][0]['formasPai'][3]['vlMinimo']).to be >= 0.0
    end
    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Input no campo ‘nome’ com dados inválidos' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      cart = build(:cart).to_hash
      carrinho = ApiCart.post_add_item_cart(@token, cart)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      credit_card = build(:credit_card).to_hash
      credit_card[:nomeCompletoTitular] = 'CARLOS 111111'
      @result = ApiCartao.post_credit_card(@token, idCarrinho, credit_card)
    end

    it { expect((@result.parsed_response)['sucesso']).to be true }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Input no campo ‘nome’ com dados vazio' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @credit_card[:nomeCompletoTitular] = ''
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it { expect((@result.parsed_response)['sucesso']).to be true }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Input no campo ‘número do cartão’ com letras e números' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredNumero] = 'erty4567rt567'
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it { expect((@result.parsed_response)['erros'][0]['mensagem']).to eql 'Tipo de cartão inválido.' }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Input no campo ‘número do cartão’ dados vazio' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredNumero] = ''
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it { expect((@result.parsed_response)['erros'][0]['mensagem']).to eql 'Tipo de cartão inválido.' }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context ' Input no campo ‘vencimento/ano’ com letras e números' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredValidadeAno] = '11aa'
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it { expect(@result.response.code).to eql '400' }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context '- Input no campo ‘vencimento/ano’ com data menor que o ano atual' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredValidadeAno] = '11'
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it { expect((@result.parsed_response)['erros'][0]['mensagem']).to eql 'Erro na confirmação do pagamento: 400 - Data de vencimento do cartão expirada. ' }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Input no campo ‘vencimento/ano’ dados vazio' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredValidadeAno] = ''
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it 'Input no campo ‘vencimento/ano’ dados vazio' do
      expect(@result.response.code).to eql '400'
      expect((@result.parsed_response)['obj.ccredValidadeAno'][0]).to eql "Error converting value {null} to type 'System.Int32'. Path 'obj.ccredValidadeAno', line 1, position 164."
    end

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Input no campo ‘vencimento/mês’ fora do intervalo de 1 a 12' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredValidadeMes] = '14'
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it { expect((@result.parsed_response)['erros'][0]['mensagem']).to eql 'Erro na confirmação do pagamento: 400 - O mês de expiração do cartão deve ser maior que 0 e menor que 13. 400 - Data de vencimento do cartão inválida. ' }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Input no campo ‘vencimento/mês’ dados vazio' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredValidadeMes] = ''
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end
    it 'Input no campo ‘vencimento/mês’ dados vazio' do
      expect(@result.response.code).to eql '400'
      expect((@result.parsed_response)['obj.ccredValidadeMes'][0]).to eql "Error converting value {null} to type 'System.Int32'. Path 'obj.ccredValidadeMes', line 1, position 140."
    end

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Input no campo ‘cvv’ com letras e números' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredCVV] = '123ss'
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it { expect((@result.parsed_response)['erros'][0]['mensagem']).to eql 'Input string was not in a correct format.' }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context '- Input no campo ‘cvv’ com 10 casa decimal' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredCVV] = '112399999999'
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it { expect((@result.parsed_response)['erros'][0]['mensagem']).to eql 'Value was either too large or too small for an Int32.' }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context ' Input no campo ‘cvv’ dados vazio  ' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @credit_card[:ccredCVV] = ''
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it { expect((@result.parsed_response)['erros'][0]['mensagem']).to eql 'Input string was not in a correct format.' }

    after do
      ApiUser.get_logout(@token)
    end
  end

  context 'Input no campo ‘nome, número do cartão, ano, mês, cvv’ com dados válidos  ' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      @credit_card = build(:credit_card).to_hash
      @result = ApiCartao.post_credit_card(@token, @idCarrinho, @credit_card)
    end

    it { expect((@result.parsed_response)['sucesso']).to be true }

    after do
      ApiUser.get_logout(@token)
    end
  end
end
