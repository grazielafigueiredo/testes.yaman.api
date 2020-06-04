# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiUserPROD
  include HTTParty
  base_uri Constant::URLPROD
  headers 'Content-Type' => 'application/json'

  def self.Login(token, user)
    payload = { "obj": user }
    post('/Usuario/LogarUsuario', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.GetToken
    token = get('/Usuario/GerarToken')
    token.parsed_response['obj'][0]['token']
  end

  def self.get_logout(token)
    get('/Usuario/DeslogarUsuario', headers: { 'Authorization' => token })
  end

  def self.post_create_new_user(new_user)
    payload = { "obj": new_user }
    post('/Usuario/CadastrarUsuario', body: payload.to_json)
  end

  def self.post_validation_data_user(new_user)
    payload = { "obj": new_user }
    post('/Usuario/ValidarDadosUsuarioCriacao', body: payload.to_json)
  end

  def self.post_change_user_data(token, change_user)
    payload = { "obj": change_user }
    post('/Usuario/AlterarDadosUsuario', body: payload.to_json, headers: { 'Authorization' => token })
  end
end

class ApiLandingPROD
  include HTTParty
  base_uri Constant::URLPROD
  headers 'Content-Type' => 'application/json', 'Authorization' => ApiUser.GetToken

  def self.get_landing_page_max
    get('/Produto/LandingPageMax')
  end

  def self.get_landing_page_ja
    get('/Produto/LandingPageJa')
  end
end

