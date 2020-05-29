# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiCreateUser
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json', 'Authorization' => ApiUser.GetToken

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

  def self.get_buscarDadosUsuario(token)
    get('/Usuario/BuscarDadosUsuario', body: @buscarDadosUsuario.to_json, headers: { 'Authorization' => token })
  end
end
