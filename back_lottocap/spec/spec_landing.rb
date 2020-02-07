# frozen_string_literal: true

describe 'Landing MAX' do
  context 'Sucesso' do
    before do

      @landingMax = ApiLanding.get_landingPageMax
      puts @landingMax
    end
    it { expect(JSON.parse(@landingMax.response.body)['sucesso']).to be true }
  end
end

describe 'Landing JÁ' do
  context 'Sucesso' do
    before do
      @token = ApiUser.GetToken()

      @landingJa = ApiLanding.get_landingPageJa(@token)
      puts @landingJa
    end
    # it { expect(JSON.parse(@landingJa.response.body)['sucesso']).to be true }
    it { expect(JSON.parse(@landingJa.response.body)['sucesso']).to be true }
  end
end