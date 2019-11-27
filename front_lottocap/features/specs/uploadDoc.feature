#     # language: pt

#     @wip
#     Funcionalidade: Upload de documentos

#     # Obs 1: o BD guardará os últimos uploads e açoes.
#     # Obs 2: portal Azures, salvará as extensoes diferentes e atualizará ultimo upload.


#     Dado que o usuário não tenha feito upload dos documentos
#     Quando eu acessar a page Meu Cadastro
#     Então o campo de "Documento" deverá apresentar unchecked  
#     Se for realizado upload
#     Então deverá apresentar checked, conforme tabela


# Tabela para massa de testes automatizados 

# | endereço | CNH | Ident. | Ident.Verso| 
# |    x     |   x |        |            |  checked
# |    x     |     |     x  |   x        |  checked
# |          |     |     x  |   x        |  unchecked
# |          |  x  |     x  |   x        |  unchecked
# |      x   |     |        |   x        |  unchecked
# |      x   |     |     x  |            |  unchecked
# |      x   | x   |     x  |   x        |  checked



