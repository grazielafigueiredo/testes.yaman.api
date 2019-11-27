# language: pt
@criar_usuario 
Funcionalidade: Novo usuário


Esquema do Cenário: Criar um cadastro de sucesso
Dado que não tenho um cadastro   
Quando crio um novo cadastro com <email>, <nome>, <cpf>
Então sou direcionado a criar <senha1>, <senha2>
E informo os dados de nascimento dia, mes, ano
Então verifico a criação do usuário

Exemplos:
| email                     | nome         | cpf           |  senha1        | senha2 | resultado |
| "graziela@gmail.com.br"   | "teste test" | "00000002054" | "1234567"  |  "1234567"     | "* É necessário ter mais de 16 anos!" |

