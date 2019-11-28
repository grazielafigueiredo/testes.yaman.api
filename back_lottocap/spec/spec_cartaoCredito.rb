# frozen_string_literal: true
require 'utils/constant'

describe 'Cartão de Crédito' do
  context 'Obter Formas Pagamento Disponiveis' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
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
  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end 
  end

  context 'Nome Inválido Cartão de Crédito ' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_NomeCartaoDeCreditoInvalido("CARLOS 111111", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }


    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'Nome Null Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_NomeCartaoDeCreditoInvalido("", @token, @idCarrinho)
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
    it { expect(@result.response.code).to eql '200' }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end 


  context 'Número Inválido Cartão de Crédito' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_NumeroCartaoDeCreditoInvalido("erty4567rt567", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Tipo de cartão inválido." }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end


  context 'Número Null Cartão de Crédito' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_NumeroCartaoDeCreditoInvalido("", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Tipo de cartão inválido." }
  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end 

  context 'Ano Inválido Cartão de Crédito' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_AnoCartaoDeCreditoInvalido("11aa", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '400' }
  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'Ano Menor que a atual Cartão de Crédito' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_AnoCartaoDeCreditoInvalido("11", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Erro na confirmação do pagamento: 400 - Data de vencimento do cartão expirada. " }

  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end


  context 'Ano Null Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_AnoCartaoDeCreditoInvalido("", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)['obj.ccredValidadeAno'][0]).to eql "Error converting value {null} to type 'System.Int32'. Path 'obj.ccredValidadeAno', line 1, position 157." }
  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end 
  end 

  context 'Mês Inválido Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_MesCartaoDeCreditoInvalido("14", @token, @idCarrinho)
    end
    # it { expect(@result.response.code)['sucesso'].to be false }
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql "Erro na confirmação do pagamento: 400 - O mês de expiração do cartão deve ser maior que 0 e menor que 13. 400 - Data de vencimento do cartão inválida. "}
    
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'Mês Null Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_MesCartaoDeCreditoInvalido("", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(JSON.parse(@result.response.body)['obj.ccredValidadeMes'][0]).to eql "Error converting value {null} to type 'System.Int32'. Path 'obj.ccredValidadeMes', line 1, position 133."}

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'CVV Inválido Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_CVVCartaoDeCreditoInvalido("123ss", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Input string was not in a correct format.' }
 
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'CVV > 4 Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_CVVCartaoDeCreditoInvalido("112399999999", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Value was either too large or too small for an Int32.' }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end
  end

  context 'CVV Null Cartão de Crédito' do
    before do

      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      @idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']

      @result = ApiCartao.post_CVVCartaoDeCreditoInvalido("", @token, @idCarrinho)
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Input string was not in a correct format.' }

  
    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)

    end 
  end


  context 'Adicionar Cartão de Crédito Sucesso' do
    before do
      @token = ApiUser.GetToken
      ApiUser.Login(@token, Constant::User1)
  
      carrinho = ApiCarrinho.post_AdicionarItemCarrinho(@token, 3)
      idCarrinho = JSON.parse(carrinho.response.body)['obj'][0]['idCarrinho']
      
      @result = ApiCartao.post_AdicionarCartaoDeCreditoSucesso(@token, idCarrinho)
    end

    it {
      expect(@result.response.code).to eql '200'
    }
    it { 
      expect(JSON.parse(@result.response.body)['sucesso']).to be true  
    }

    after do 
      ApiCarrinho.post_SetRemoverItemCarrinho(@token, @idCarrinho)
      ApiUser.get_deslogar(@token)
    end
  end
end


