# frozen_string_literal: true

require 'utils/constant'

class ApiLanding
  include HTTParty
  base_uri Constant::URI_HOMOLOG
  headers 'Content-Type' => 'application/json', 'Authorization' => ApiUser.GetToken

  def self.get_landing_page_max
    get('/Produto/LandingPageMax')
  end

  def self.get_landing_page_ja
    get('/Produto/LandingPageJa')
  end
end
