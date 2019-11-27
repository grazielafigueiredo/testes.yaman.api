# frozen_string_literal: true

# boleto - final de serie
# feriado 


describe 'post' do

    context 'Fim da série acaba hj e deve mudar no banco e indisponibilizar, bloquear pagamento' do
      before do
        @carrinho = ApiBoleto.post_AdicionarItemCarrinho(2)

        # Database.new.update_BloquearPagamento
        @result = ApiPagamento.post_ObterFormasPagamentoDisponiveis

      end
      it { expect(@carrinho.response.code).to eql '200' }
      it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][1]['msgErro']).to  "Indisponível para compra de títulos LottoCap Max - Max Série Nova (id 88)devido ao fim da série em '#{Constant::TimeMsg}'. Remova esse título do carrinho ou escolha outra forma de pagamento." }

      after do 
        #voltar no banco a data futura 
      end
    end
end


