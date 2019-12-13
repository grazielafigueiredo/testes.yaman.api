# frozen_string_literal: true

require 'utils/constant'

class ApiLanding
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.get_LandingPageMax()


    get('/Produto/LandingPageMax', body: @LandingPageMax.to_json)
  end
end
