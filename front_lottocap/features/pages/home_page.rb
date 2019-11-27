#  class HomePage < SitePrism::Pagest

#     set
#     element :campo_cpf, '#usurio-1'
#     element :campo_senha, '#senha-1'
#     element :button_entrar, 'button[type="submit"]'
    
#     def logar_user(cpf, senha)
#         campo_cpf.set cpf
#         campo_senha. set senha
#         button_entrar.click
#     end
#  end