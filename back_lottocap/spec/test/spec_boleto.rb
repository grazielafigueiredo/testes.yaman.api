# frozen_string_literal: true

describe 'Boleto' do
  context 'Apresentar forma de pagamento indisponível quando a série está no último dia de vigência' do
    before do
      carrinho = ApiCart.post_add_item_cart(@token, build(:cart).to_hash)
      idCarrinho = carrinho.parsed_response['obj'][0]['idCarrinho']

      BoletoDB.new.update_final_date(Time.now.strftime('%F'))

      @result = ApiBoleto.post_payment_cart_boleto(@token, idCarrinho, build(:boleto).to_hash)
    end

    it {
      expect(@result.parsed_response['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.'
    }

    after do
      BoletoDB.new.update_final_date(Date.today + 10)
    end
  end
end
