# frozen_string_literal: true

require 'utils/constant'

class ApiUser
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.Login(token, user)
    payload = { "obj": user }
    post('/Usuario/LogarUsuario', body: payload.to_json, headers: { 'Authorization' => token })
    # result.parsed_response['obj'][0]['token']
  end

  def self.GetToken
    token = get('/Usuario/GerarToken')
    token.parsed_response['obj'][0]['token']
  end

  def self.get_logout(token)
    get('/Usuario/DeslogarUsuario', headers: { 'Authorization' => token })
  end
end

# class Token
#     include Singleton

#     def initialize()
#         @token = ApiUser.GetToken()
#     end

#     def get()
#         return @token
#     end
# end
