# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiTitulos
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'

  def self.post_group_titulos_serie(token)
    payload = { "obj": {} }
    post('/Usuario/BuscarTitulosAgrupadosPorSerie', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.post_get_new_titulo(token)
    payload = { "obj": {} }
    post('/Usuario/GetTitulosNovos', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.post_premium_titulo(token, idTitulo)
    payload = { "obj": idTitulo }
    post('/Usuario/VerificarPremioTitulo', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.post_open_titulo(token, idTitulo)
    payload = { "obj": idTitulo }
    post('/Titulo/AbrirTitulo', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.post_closed_titulo(token)
    payload = { "obj": {} }
    post('/Usuario/BuscarTitulosNaoAbertosUsuario', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.post_GetMultiplicador(token, idTitulo)
    payload = { "obj": idTitulo }
    post('/Titulo/GetMultiplicador', body: payload.to_json, headers: { 'Authorization' => token })
  end

  def self.get_amount_titulo(token)
    get('/Usuario/GetQtdTitulosUsuario', headers: { 'Authorization' => token })
  end
end
