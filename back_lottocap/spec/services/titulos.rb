# frozen_string_literal: true

require 'utils/constant'
require 'services/user'

class ApiTitulos
  include HTTParty
  base_uri Constant::Url
  headers 'Content-Type' => 'application/json'


  def self.post_BuscarTitulosAgrupadosPorSerie(token)
    headers['Authorization'] = token

    @titulosAgrupados = {
        "obj": {},
        "tamanhoPagina": 9999,
        "atualPagina": 1
    }
    post('/Usuario/BuscarTitulosAgrupadosPorSerie', body: @titulosAgrupados.to_json)
  end

  def self.post_GetTitulosNovos(token)
    headers['Authorization'] = token

    @GetTitulosNovos = {
        "obj": {}
    }
    post('/Usuario/GetTitulosNovos', body: @GetTitulosNovos.to_json)
  end

  def self.post_VerificarPremioTitulo(token, idTitulo)
    headers['Authorization'] = token

    @VerificarPremioTitulo = {
      "obj": {
        "idTitulo": idTitulo
      }
    }
    post('/Usuario/VerificarPremioTitulo', body: @VerificarPremioTitulo.to_json)
  end

  def self.post_AbrirTitulo(token, idTitulo)
    headers['Authorization'] = token

    @AbrirTitulo = {
      "obj": {
        "idTitulo": idTitulo
      }
    }
    post('/Titulo/AbrirTitulo', body: @AbrirTitulo.to_json)
  end

  def self.post_BuscarTitulosNaoAbertosUsuario(token)
    headers['Authorization'] = token

    @BuscarTitulosNaoAbertosUsuario = {
      "obj": {},
      "atualPagina": 0,
      "tamanhoPagina": 0
    }
    post('/Usuario/BuscarTitulosNaoAbertosUsuario', body: @BuscarTitulosNaoAbertosUsuario.to_json)
  end

  def self.post_GetMultiplicador(token)
    headers['Authorization'] = token

    @GetMultiplicador = {
      "obj": {
        "idTitulo": 62178 #titulo JÁ
      }
    }
    post('/Titulo/GetMultiplicador', body: @GetMultiplicador.to_json)
  end

  def self.get_GetQtdTitulosUsuario(token)
    headers['Authorization'] = token

    get('/Usuario/GetQtdTitulosUsuario', body: @GetQtdTitulosUsuario.to_json)
  end
end

