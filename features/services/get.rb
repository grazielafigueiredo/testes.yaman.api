# frozen_string_literal: true

class ApiGet
  include HTTParty
  base_uri CONFIG['base_uri']

  def self.api_get(id)
    get("/1/actions/#{id}")
  end
end
