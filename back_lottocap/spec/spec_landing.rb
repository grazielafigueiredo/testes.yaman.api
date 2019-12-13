# frozen_string_literal: true

describe 'Landing' do
  context 'Sucesso' do
    before do

      @result = ApiLanding.get_LandingPageMax()
      puts @result
    end
    it { expect(JSON.parse(@result.response.body)['sucesso']).to be true }
  end
end
