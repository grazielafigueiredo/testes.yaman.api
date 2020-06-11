# frozen_string_literal: true


#criar teste validando que o retorno dos numeros nao se repete
describe 'RGN' do
  context 'Validar se estrutura retorna corretamente' do
    let(:result) { ApiRNG.post_rng(build(:rng).to_hash) }

    it '' do
      expect(result.parsed_response['mensagem']).to eql 'Número gerado com sucesso.'
      expect(result.parsed_response['dados']['data']).to be_a_kind_of(String)
      expect(result.parsed_response['dados']['cliente']).to be_a_kind_of(String)
      expect(result.parsed_response['dados']['origemIp']).to be_a_kind_of(String)
      expect(result.parsed_response['dados']['hashAuditoria']).to be_a_kind_of(String)
      expect(result.parsed_response['dados']['hashAtual']).to be_a_kind_of(String)
      expect(result.parsed_response['dados']['produto']).to be_a_kind_of(String)
      expect(result.parsed_response['dados']['concurso']).to be_a_kind_of(String)
      expect(result.parsed_response['dados']['objetivo']).to be_a_kind_of(String)
      expect(result.parsed_response['dados']['numeroMaximo']).to be_a_kind_of(Integer)
      expect(result.parsed_response['dados']['numerosSorteados'].count).to be 3
      expect(result.parsed_response['dados']['id']).to be_a_kind_of(String)
      expect(JSON.parse(result.response.code)).to be 200
    end
  end

  context 'Enviar tipagem de dados com atributo null' do
    before do
      rng = build(:rng).to_hash
      rng[:produto] = nil
      rng[:concurso] = nil
      rng[:objetivo] = nil
      @result = ApiRNG.post_rng(rng)
    end
    it { expect(JSON.parse(@result.response.code)).to be 500 }
  end

  context 'Trocar tipagem numérica para alfanumérico' do
    before do
      rng = build(:rng).to_hash
      rng[:numeroMaximo] = '1234ABC'
      rng[:qtdDezenasSorteadas] = '1234ABC'
      @result = ApiRNG.post_rng(rng)
    end
    it '' do
      expect(JSON.parse(@result.response.code)).to be 400
    end
  end

  context 'Não informar número máximo e quantidade de dezenas' do
    before do
      rng = build(:rng).to_hash
      rng[:numeroMaximo] = 0
      rng[:qtdDezenasSorteadas] = 0
      @result = ApiRNG.post_rng(rng)
    end
    it '' do
      expect(@result.parsed_response['mensagem']).to eql 'Dados para geração de número aleatório inválidos.'
      expect(@result.parsed_response['dados']).to eql ['Numero máximo precisa ser informado', 'Numero maximo menor do que a quantidade de dezenas à serem sorteadas']
    end
  end
end
