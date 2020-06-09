# frozen_string_literal: true

describe 'Resgate' do
  context '[Bradesco] - Resgate e verificação de saldo restante' do
    before do
      RescueDB.new.update_premium_rescue(@idUsuario, 50.000)
      date_rescue = build(:rescue).to_hash
      ApiRescue.post_set_rescue(@token, date_rescue)
      @status_rescue = ApiRescue.get_status_rescue(@token)
    end

    it '[Bradesco] - Resgate e verificação de saldo restante' do
      expect((@status_rescue.parsed_response)['obj'][0]['saldoPremio']).to be 40.0
      expect((@status_rescue.parsed_response)['sucesso']).to be true
      expect((@status_rescue.parsed_response)['sucesso']).to be true
    end
  end

  context '[Santander] - Resgate e verificação de saldo restante' do
    before do
      RescueDB.new.update_premium_rescue(@idUsuario, 50.000)
      date_rescue = build(:rescue).to_hash
      date_rescue[:idBanco] = 3
      ApiRescue.post_set_rescue(@token, date_rescue)
      @status_rescue = ApiRescue.get_status_rescue(@token)
    end

    it '[Santander] - Resgate e verificação de saldo restante' do
      expect((@status_rescue.parsed_response)['obj'][0]['saldoPremio']).to be 40.0
      expect((@status_rescue.parsed_response)['sucesso']).to be true
      expect((@status_rescue.parsed_response)['sucesso']).to be true
    end
  end

  context 'Resgatar valor acima do valor disponível para saque' do
    before do
      RescueDB.new.update_premium_rescue(@idUsuario, 50.000)
      date_rescue = build(:rescue).to_hash
      date_rescue[:valor] = 50.500
      @rescue = ApiRescue.post_set_rescue(@token, date_rescue)
    end

    it { expect((@rescue.parsed_response)['erros'][0]['mensagem']).to eql 'Não é possível resgatar o valor solicitado (saldo insuficiente)' }
  end

  context 'Resgatar valor menor que a taxa de resgate' do
    before do
      RescueDB.new.update_premium_rescue(@idUsuario, 4.750)
      date_rescue = build(:rescue).to_hash
      date_rescue[:valor] = 3.500
      @rescue = ApiRescue.post_set_rescue(@token, date_rescue)
    end

    it { expect((@rescue.parsed_response)['erros'][0]['mensagem']).to eql 'Não é possível resgatar o valor solicitado (valor menor que taxa de resgate)' }
  end

  context 'Resgatar com uma conta já cadastrada anteriormente na base' do
    before do
      RescueDB.new.delete_account(@idUsuario)
      RescueDB.new.insert_account(@idUsuario)
      RescueDB.new.update_premium_rescue(@idUsuario, 50.750)

      date_rescue = build(:rescue).to_hash
      @rescue = ApiRescue.post_set_rescue(@token, date_rescue)
    end

    it { expect((@rescue.parsed_response)['sucesso']).to be true }
  end

  context 'Resgatar valor inserindo dados bancários fakers' do
    before do
      RescueDB.new.update_premium_rescue(@idUsuario, 50.000)
      date_rescue = build(:rescue).to_hash
      date_rescue[:agenciaNumero] = Faker::Bank.account_number(digits: 4)
      date_rescue[:agenciaDigito] = Faker::Bank.account_number(digits: 1)
      date_rescue[:contaNumero] = Faker::Bank.account_number(digits: 10)
      date_rescue[:contaDigito] = Faker::Bank.account_number(digits: 1)
      @rescue = ApiRescue.post_set_rescue(@token, date_rescue)
    end

    it { expect((@rescue.parsed_response)['sucesso']).to be true }
  end
end
