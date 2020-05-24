# frozen_string_literal: true

describe 'Landing MAX' do
  context 'Sucesso' do
    before do
      @landingMax = ApiLanding.get_landing_page_max
    end
    it { expect(@landingMax.parsed_response['sucesso']).to be true }
  end
end

describe 'Landing JÁ' do
  context 'Sucesso' do
    before do
      @landingJa = ApiLanding.get_landing_page_ja
    end
    it { expect(@landingJa.parsed_response['sucesso']).to be true }
  end
end
