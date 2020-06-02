# frozen_string_literal: true
require 'timeout'

describe 'Boleto' do
  context 'Apresentar forma de pagamento indisponível quando a série está no último dia de vigência' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, build(:login).to_hash)
      @cart = build(:cart).to_hash
      @carrinho = ApiCart.post_add_item_cart(@token, @cart)
      @idCarrinho = @carrinho.parsed_response['obj'][0]['idCarrinho']

      BoletoDB.new.update_final_date(Time.now.strftime('%F'))

      @payment_boleto = build(:boleto).to_hash
      @result = ApiBoleto.post_payment_cart_boleto(@token, @idCarrinho, @payment_boleto)
    end

    it {
      expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.'
    }

    after do
      BoletoDB.new.update_final_date(Date.today + 10)
      ApiUser.get_logout(@token)
    end
  end
end
