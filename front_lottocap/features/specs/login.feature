# language: pt

@login_user
Funcionalidade: Fazer login

# -Eu como usuário admin.
# -Eu quero fazer login na plataforma

Contexto:
Dado que o usuário possa acessar a tela de login do sistema

@login_invalido
Esquema do Cenário: Fazer login com usuário inválido
Quando eu faço login com um <email> e <senha>
Então verifico <resultado> dos dados inseridos.

Exemplos:
| email            | senha        | resultado|
| "gra@gmail.com"  | "Trade@2019" | "* Usuário e/ou Senha incorretos"|
| "graziela@gmail" | "1"          | "Informe um email válido." |
| "gra@gmail.com"  | ""           | "Senha é obrigatória."|

@login_sucesso @deslogar
Esquema do Cenário: Fazer login com usuário de sucesso
Quando eu faço login com um <email> e <senha>
Então verifico se o usuário está logado <resultado>

Exemplos:
| email                      | senha      | resultado|
| "graziela@lottocap.com.br" | "lottocap" | "Graziela"|
