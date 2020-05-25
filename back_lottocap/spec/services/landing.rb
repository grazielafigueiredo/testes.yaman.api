# frozen_string_literal: true

require 'utils/constant'

class ApiLanding
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json', 'Authorization' => ApiUser.GetToken

  def self.get_landing_page_max
    get('/Produto/LandingPageMax', body: @landingPageMax.to_json)
  end

  def self.get_landing_page_ja
    get('/Produto/LandingPageJa', body: @landingPageJa.to_json)
  end
end
