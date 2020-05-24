# frozen_string_literal: true

describe 'Boleto' do
  context 'Apresentar forma de pagamento indisponível quando a série está no último dia de vigência' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCarrinho.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      Database.new.update_bloquearPagamento

      @payment_boleto = build(:boleto).to_hash
      @result = ApiBoleto.post_payment_cart_boleto(@token, @payment_boleto, @idCarrinho)
    end
    it {
      expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.'
    }

    after do
      CarrinhoDb.new.update_dataFinalVendaVigente('2020-12-25')
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end
