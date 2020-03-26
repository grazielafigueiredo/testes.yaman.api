# frozen_string_literal: true

describe 'Boleto' do
  context 'Fim da série acaba hoje e forma de pagamento deve ficar indisponível' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )
      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']

      Database.new.update_bloquearPagamento
      @boleto = ApiBoleto.post_pagarCarrinhoComBoleto(@token, @idCarrinho)
    end
    it { expect(JSON.parse(@boleto.response.body)['erros'][0]['mensagem']).to eql 'Esta forma de pagamento não está mais disponível, por favor. Selecione outra forma de pagamento.' }

    after do
      CarrinhoDb.new.update_dataFinalVendaVigente('2020-12-25')
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end
