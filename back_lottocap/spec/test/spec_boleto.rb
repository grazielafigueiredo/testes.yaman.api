# frozen_string_literal: true

describe 'Boleto' do
  context 'Apresentar forma de pagamento indisponível quando a série está no último dia de vigência' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      BoletoDB.new.update_final_date

      @payment_boleto = build(:boleto).to_hash
      @result = ApiBoleto.post_payment_cart_boleto(@token, @idCarrinho, @payment_boleto)
    end

    it {
      expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.'
    }

    after do
      CartDB.new.update_dataFinalVendaVigente('2020-12-25')
      ApiCart.post_set_remover_item_cart(@token, @idCarrinho)
      ApiUser.get_logout(@token)
    end
  end
end
