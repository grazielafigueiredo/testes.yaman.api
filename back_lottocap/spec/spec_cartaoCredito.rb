# frozen_string_literal: true
require 'utils/constant'

describe 'Cartão de Crédito' do
  context 'Obter Formas Pagamento Disponiveis' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiCartao.post_ObterFormasPagamentoDisponiveis(@token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][0]['tipo']).to eql 'cartao_credito' }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][0]['nome']).to eql 'Cartão de Crédito' }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][0]['idFormaPagamento'][0]).to be 1 }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][0]['vlMinimo']).to be >= 5.0 }

    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][1]['tipo']).to eql 'transf_bancaria' }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][1]['idFormaPagamento']).to be 2 }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][1]['vlMinimo']).to be >= 5.0 }

    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][2]['tipo']).to eql 'boleto' }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][2]['idFormaPagamento']).to be 3 }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][2]['vlMinimo']).to be >= 20.0 }

    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][3]['tipo']).to eql 'credito' }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][3]['idFormaPagamento']).to be 4 }
    it { expect(JSON.parse(@result.response.body)['obj'][0]['formasPai'][3]['vlMinimo']).to be >= 0.0 }
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end

  context 'Nome Inválido Cartão de Crédito ' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, "CARLOS 111111", Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'Nome Vazio Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, "", Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { expect(@result.response.code).to eql '200' }
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end 


  context 'Número Inválido Cartão de Crédito' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, "erty4567rt567", Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Tipo de cartão inválido." }
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end


  context 'Número Vazio Cartão de Crédito' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, "", Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Tipo de cartão inválido." }
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end 

  context 'Ano Inválido Cartão de Crédito' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, "11aa", Constant::CartaoCVV)
    end
    it { expect(@result.response.code).to eql '400' }
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'Ano Menor que o atual' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, "11", Constant::CartaoCVV)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Erro na confirmação do pagamento: 400 - Data de vencimento do cartão expirada. " }
    it { puts @result.response.body}

  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end


  context 'Ano Vazio Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, "", Constant::CartaoCVV)
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)['obj.ccredValidadeAno'][0]).to eql "Error converting value {null} to type 'System.Int32'. Path 'obj.ccredValidadeAno', line 1, position 157." }
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end 
  end 

  context 'Mês Inválido Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, "14", Constant::ValidadeAnoCartao, Constant::CartaoCVV)
    end
    # it { expect(@result.response.code)['sucesso'].to be false }
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Erro na confirmação do pagamento: 400 - O mês de expiração do cartão deve ser maior que 0 e menor que 13. 400 - Data de vencimento do cartão inválida. "}
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'Mês Vazio Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, "", Constant::ValidadeAnoCartao, Constant::CartaoCVV)
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)['obj.ccredValidadeMes'][0]).to eql "Error converting value {null} to type 'System.Int32'. Path 'obj.ccredValidadeMes', line 1, position 133."}
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'CVV Inválido Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, "123ss")
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Input string was not in a correct format.' }
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'CVV > 10 Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, "112399999999")
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Value was either too large or too small for an Int32.' }
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'CVV Vazio Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, "")
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Input string was not in a correct format.' }
    it { puts @result.response.body}

  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end 
  end


  context 'Adicionar Cartão de Crédito Sucesso' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(1, Constant::IdProduto, Constant::IdSerie, @token)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiCartao.post_PagarCartaoDeCredito(@token, @idCarrinho, Constant::NomeCompletoTitular, Constant::NumeroCartao, Constant::ValidadeMesCartao, Constant::ValidadeAnoCartao, Constant::CartaoCVV)
    end

    it { expect(@result.response.code).to eql '200'}
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { puts @result.response.body}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end


