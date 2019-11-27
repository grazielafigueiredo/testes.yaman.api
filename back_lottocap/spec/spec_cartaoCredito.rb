# frozen_string_literal: true

describe 'Cartão de Crédito' do
  context 'Obter Formas Pagamento Disponiveis' do
    before do
      ApiCarrinho.post_AdicionarItemCarrinho(3)
      @result = ApiPagamento.post_ObterFormasPagamentoDisponiveis
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
  
    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end 
  end

  # context 'Data expirada da venda' do
  #   before do

  #     Database.new.update_DataFinalVendaVigente
  #     @result = ApiPagamento.post_AdicionarCartaoDeCreditoSucesso


  #   end
  #   it { expect(@result.response.code).to eql '200' }
  #   it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
  # end

  context 'Nome Inválido Cartão de Crédito ' do
    before do
      @result = ApiPagamento.nomeCompletoTitular("CARLOS 111111")
    end
    it { expect(@result.response.code)['sucesso'].to be true }
    it { expect(@result.response.code).to eql '200' }


    it{
      puts @result.response.code['sucesso']
    }

    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end
  end

  context 'Nome Null Cartão de Crédito' do
    before do
      @result = ApiPagamento.nomeCompletoTitular("")
    end
    it { expect(@result.response.code)['sucesso'].to be true }
    it { expect(@result.response.code).to eql '200' }


    it{
      puts @result.response.code['sucesso']
    }

    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end
  end 

  # context 'Teste logar, deslogar' do
  #   before do
  #     @token = ApiUser.login(USER_TEST)
  #     @result = ApiPagamento(@token).post_AdicionarCartaoDeCreditoNomeInvalido
  #     #  ApiPagamento.get_GetStatusCarrinho
  #      @id_carrinho = ApiPagamento.post_AdicionarItemCarrinho(30, idCarrinho)
  #      ApiPagamento.post_AdicionarCartaoDeCreditoSucesso(@id_carrinho)
  #   end

  #   it { expect(@result.response.code)['sucesso'].to be true }
  #   it { expect(@result.response.code).to eql '200' }
  #   it{ puts @result.response.code['sucesso'] }

  #   after do 
  #     ApiUser.get_deslogar(@token)
  #   end
  # end


  context 'Número Inválido Cartão de Crédito' do
    before do
      @result = ApiPagamento.post_NumeroCartaoDeCreditoInvalido("erty4567rt567")
    end
    it { expect(@result.response.code).to eql '500' }
    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end
  end


  context 'Número Null Cartão de Crédito' do
    before do
      @result = ApiPagamento.post_NumeroCartaoDeCreditoInvalido("")
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(@result.response.code)['sucesso'].to be false }
    # it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'O campo Numero do Cartao nao pode ser Null' }
  
    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end
  end 

  context 'Ano Inválido Cartão de Crédito' do
    before do
      @result = ApiPagamento.post_AnoCartaoDeCreditoInvalido("11aa")
    end
    it { expect(@result.response.code).to eql '400' }
  
    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end
  end

  context 'Ano Menor que a atual Cartão de Crédito' do
    before do
      @result = ApiPagamento.post_AnoCartaoDeCreditoInvalido("11")
    end
    it { expect(@result.response.code).to eql '400' }
  
    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end
  end


  context 'Ano Null Cartão de Crédito' do
    before do
      @result = ApiPagamento.post_AnoCartaoDeCreditoInvalido("")
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(@result.response.code)['sucesso'].to be false }
  
    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end  
  end 
  context 'Mês Inválido Cartão de Crédito' do
    before do
      @result = ApiPagamento.post_MesCartaoDeCreditoInvalido("14")
    end
    # it { expect(@result.response.code)['sucesso'].to be false }
    it { expect(@result.response.code).to eql '500' }

    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end
  end

  context 'Mês Null Cartão de Crédito' do
    before do
      @result = ApiPagamento.post_MesCartaoDeCreditoInvalido("")
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(@result.response.code)['sucesso'].to be false }
    # it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'O campo Mes nao pode ser Null' }
  
    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end
  end

  context 'CVV Inválido Cartão de Crédito' do
    before do
      @result = ApiPagamento.post_CVVCartaoDeCreditoInvalido("123ss")
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Input string was not in a correct format.' }
 
    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end
  end

  context 'CVV > 4 Cartão de Crédito' do
    before do
      @result = ApiPagamento.post_CVVCartaoDeCreditoInvalido("112399999999")
    end
    it { expect(@result.response.code).to eql '200' }
    it { expect(JSON.parse(@result.response.body)['erros'][0]['mensagem']).to eql 'Value was either too large or too small for an Int32.' }

    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end
  end

  context 'CVV Null Cartão de Crédito' do
    before do
      @result = ApiPagamento.post_CVVCartaoDeCreditoInvalido("")
    end
    it { expect(@result.response.code).to eql '400' }
    it { expect(@result.response.code)['sucesso'].to be false }
  
    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end  
  end


  # context 'Adicionar Cartão de Crédito Sucesso' do
  #   before do
  #     @result = ApiPagamento.post_AdicionarCartaoDeCreditoSucesso
  #   end
  #   it { expect(@result.response.code).to eql '200' }
  #   it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
  # end

    # after do 
    #   ApiCarrinho.post_SetRemoverItemCarrinho
    # end 
end


