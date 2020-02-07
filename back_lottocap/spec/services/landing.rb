# frozen_string_literal: true

require 'utils/constant'

class ApiLanding
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.get_landingPageMax


    get('/Produto/LandingPageMax', body: @landingPageMax.to_json)
  end

  def self.get_landingPageJa(token)
    headers['Authorization'] = token


    get('/Produto/LandingPageJa', body: @landingPageJa.to_json)
  end

end
