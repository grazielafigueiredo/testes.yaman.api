# frozen_string_literal: true

Quando('faço uma requisição GET para o serviço') do
  @request = ApiGet.api_get
end

Então('o serviço deve responder com status code {int}') do |status_code|
  expect(@request.code).to eq status_code
end

Então('retornar name da estrutura list') do
  name = (@request.parsed_response['data']['list']['name'])
  print name

  expect(name).to eq 'Professional'
end
