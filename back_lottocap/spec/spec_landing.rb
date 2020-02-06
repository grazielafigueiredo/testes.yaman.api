# frozen_string_literal: true

describe 'Landing MAX' do
  context 'Sucesso' do
    before do

      @result = ApiLanding.get_landingPageMax()
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
  end
end

describe 'Landing JÁ' do
  context 'Sucesso' do
    before do

      @result = ApiLanding.get_landingPageJa()
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
  end
end