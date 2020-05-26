# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiCreateUser
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json', 'Authorization' => ApiUser.GetToken

  def self.post_create_new_user(payload)
    post('/Usuario/CadastrarUsuario', body: payload.to_json)
  end

  def self.post_validation_data_user(payload)
    post('/Usuario/ValidarDadosUsuarioCriacao', body: payload.to_json)
  end

  def self.post_change_user_data(token, payload)
    headers['Authorization'] = token
    v = post('/Usuario/AlterarDadosUsuario', body: payload.to_json)
    puts v

    return v
  end

  def self.get_buscarDadosUsuario(token)
    headers['Authorization'] = token
    get('/Usuario/BuscarDadosUsuario', body: @buscarDadosUsuario.to_json)
  end
end
