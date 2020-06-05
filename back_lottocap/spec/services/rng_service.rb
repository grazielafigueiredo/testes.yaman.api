# frozen_string_literal: true

require 'utils/constant'

class ApiRNG
  include HTTParty
  # base_uri Constant::URI_HOMOLOG
  headers 'Content-Type' => 'application/json'

  def self.post_rng(rng)
    post('https://lottocap-rng-hml.azurewebsites.net/v1/gerador', body: rng.to_json)
  end
end
