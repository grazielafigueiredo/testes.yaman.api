# frozen_string_literal: true

class ApiGet
  include HTTParty
  base_uri 'https://api.trello.com'

  def self.api_get(id)
    get('/1/actions/592f11060f95a3d3d46a987a')
    get("/1/actions/#{id}")
  end
end
