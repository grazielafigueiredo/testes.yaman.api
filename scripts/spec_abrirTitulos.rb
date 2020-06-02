
# context 'Loop' do
#   before do
#     @token = ApiUser.GetToken
#     ApiUser.Login(@token, build(:login).to_hash)

#       900.times do
#         @tituloJa = ApiTitulos.post_GetTitulosNovos(@token)
#         @idTitulo = (@tituloJa.parsed_response)['obj'][0]['novosTitulos'][0]['idTitulo']
#         @result = ApiTitulos.post_VerificarPremioTitulo(@token, @idTitulo)
#         ApiTitulos.post_AbrirTitulo(@token, @idTitulo)
#         puts @idTitulo
#         puts @result
#       end
#   end

#   it { expect((@result.parsed_response)['sucesso']).to be true }

#   after do
#     ApiUser.get_logout(@token)
#   end
# end

# context 'loops' do
#   before do
#     @token = ApiUser.GetToken
#     ApiUser.Login(@token, build(:login).to_hash)

#     Database.new.update_DataFinalVendaVigente('2020-12-25')

#     carrinho = ApiCart.post_AdicionarItemCarrinho(
#       1,
#       Constant::IdProduto,
#       Constant::IdSerieMaxRegular,
#       @token
#     )

#     @idCarrinho = (carrinho.parsed_response)['obj'][0]['idCarrinho']

#     @result = ApiCartao.post_PagarCartaoDeCredito(
#       @token,
#       @idCarrinho,
#       'CARLOS',
#       '5521884306233764',
#       '11',
#       Constant::ValidadeAnoCartao,
#       '123'
#     )

#     @tituloJa = ApiTitulos.post_GetTitulosNovos(@token)
#     idTitulo = expect((@tituloJa.parsed_response)['obj'][0]['novosTitulos'][0]['idTitulo']).to be_a Integer

#     while idTitulo # variável para rodar o loop, enqto a variável retornar Integer

#       @tituloJa = ApiTitulos.post_GetTitulosNovos(@token)
#       @idTitulo = (@tituloJa.parsed_response)['obj'][0]['novosTitulos'][0]['idTitulo']
#       @result = ApiTitulos.post_VerificarPremioTitulo(@token, @idTitulo)

#       ApiTitulos.post_AbrirTitulo(@token, @idTitulo)
#       puts @result
#       puts @idTitulo

#     end
#   end

#   it {
#     expect((@result.parsed_response)['sucesso']).to be true
#   }

#   after do
#     ApiUser.get_logout(@token)
#   end
# end
