# frozen_string_literal: true
require 'utils/constant'

describe 'Cartão de Crédito' do
  
  dataVincenda = '2020-12-25'

  context 'validar se todas as formas de pagamento estão disponíveis seguindo regra de valor mínimo para compra' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_ObterFormasPagamentoDisponiveis(@token, @idCarrinho)
      puts @result
    end
    it 'validar se todas as formas de pagamento estão disponíveis seguindo regra de valor mínimo para compra' do
        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][0]['tipo']).to eql 'cartao_credito' 
        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][0]['nome']).to eql 'Cartão de Crédito' 
        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][0]['idFormaPagamento'][0]).to be 1 
        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][0]['vlMinimo']).to be >= 5.0 

        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][1]['tipo']).to eql 'transf_bancaria' 
        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][1]['idFormaPagamento']).to be 2 
        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][1]['vlMinimo']).to be >= 5.0 

        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][2]['tipo']).to eql 'boleto' 
        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][2]['idFormaPagamento']).to be 3 
        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][2]['vlMinimo']).to be >= 20.0 

        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][3]['tipo']).to eql 'credito' 
        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][3]['idFormaPagamento']).to be 4 
        expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][3]['vlMinimo']).to be >= 0.0 
    end
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end

  context 'Input no campo ‘nome’ com dados inválidos' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      @carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )

      @idCarrinho = JSON.parse(@carrinho.response.body)['obj'][0]['idCarrinho']
      puts @carrinho

      
      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token,
        @idCarrinho,
        'CARLOS 111111',
        '5521884306233764',
        '11',
        Constant::ValidadeAnoCartao,
        '123'
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Input no campo ‘nome’ com dados vazio' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token,
        @idCarrinho,
        "",
        '5521884306233764',
        '11',
        Constant::ValidadeAnoCartao,
        '123'
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end 


  context 'Input no campo ‘número do cartão’ com letras e números' do
    before do
      @token = ApiUser.GetToken
      @t = ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)
      puts @token
      puts @t
      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )
      puts @carrinho
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token,
        @idCarrinho,
        'CARLOS',
        "erty4567rt567",
        '11',
        Constant::ValidadeAnoCartao,
        '123'
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Tipo de cartão inválido." }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end


  context 'Input no campo ‘número do cartão’ dados vazio' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token,
        @idCarrinho,
        'CARLOS',
        "",
        '11',
        Constant::ValidadeAnoCartao,
        '123'
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Tipo de cartão inválido." }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end 

  context ' Input no campo ‘vencimento/ano’ com letras e números' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token,
        @idCarrinho,
        'CARLOS',
        '5521884306233764',
        '11',
        "11aa",
        '123'
      )
      puts @result
    end
    it { expect(@result.response.code).to eql '400' }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context '- Input no campo ‘vencimento/ano’ com data menor que o ano atual' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token,
        @idCarrinho,
        'CARLOS',
        '5521884306233764',
        '11',
        "11",
        '123'
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Erro na confirmação do pagamento: 400 - Data de vencimento do cartão expirada. " }

  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end


  context 'Input no campo ‘vencimento/ano’  dados vazio' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1,
        Constant::IdProduto,
        Constant::IdSerieMaxRegular,
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token, 
        @idCarrinho, 
        'CARLOS', 
        '5521884306233764', 
        '11', 
        "", 
        '123'
      )
      puts @result
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)['obj.ccredValidadeAno'][0]).to eql "Error converting value {null} to type 'System.Int32'. Path 'obj.ccredValidadeAno', line 1, position 157." }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end 

  context 'Input no campo ‘vencimento/mês’ fora do intervalo de 1 a 12' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token, 
        @idCarrinho, 
        'CARLOS', 
        '5521884306233764', 
        "14", 
        Constant::ValidadeAnoCartao, 
        '123'
      )
      puts @result
    end
    # it { expect(@result.response.code)['sucesso'].to be false }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Erro na confirmação do pagamento: 400 - O mês de expiração do cartão deve ser maior que 0 e menor que 13. 400 - Data de vencimento do cartão inválida. "}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Input no campo ‘vencimento/mês’ dados vazio' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token, 
        @idCarrinho, 
        'CARLOS', 
        '5521884306233764', 
        "", 
        Constant::ValidadeAnoCartao, 
        '123'
      )
      puts @result
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)['obj.ccredValidadeMes'][0]).to eql "Error converting value {null} to type 'System.Int32'. Path 'obj.ccredValidadeMes', line 1, position 133."}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context 'Input no campo ‘cvv’ com letras e números' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token, 
        @idCarrinho, 
        'CARLOS', 
        '5521884306233764', 
        '11', 
        Constant::ValidadeAnoCartao, 
        "123ss"
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Input string was not in a correct format.' }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context '- Input no campo ‘cvv’ com 10 casa decimal' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token, 
        @idCarrinho, 
        'CARLOS', 
        '5521884306233764', 
        '11', 
        Constant::ValidadeAnoCartao, 
        "112399999999"
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Value was either too large or too small for an Int32.' }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end

  context ' Input no campo ‘cvv’ dados vazio  ' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token, 
        @idCarrinho, 
        'CARLOS', 
        '5521884306233764', 
        '11', 
        Constant::ValidadeAnoCartao, 
        ""
      )
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Input string was not in a correct format.' }

  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end


  context 'Input no campo ‘nome, número do cartão, ano, mês, cvv’ com dados válidos  ' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)

      CarrinhoDb.new.update_dataFinalVendaVigente(dataVincenda)

      carrinho = ApiCarrinho.post_adicionarItemCarrinho(
        1, 
        Constant::IdProduto, 
        Constant::IdSerieMaxRegular, 
        @token
      )

      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiCartao.post_PagarCartaoDeCredito(
        @token, 
        @idCarrinho, 
        'CARLOS', 
        '5521884306233764', 
        '11', 
        Constant::ValidadeAnoCartao, 
        '123'
      )
      puts @result
    end

    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end


