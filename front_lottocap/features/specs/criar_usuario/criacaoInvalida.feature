# language: pt
@criar_usuario_invalido @ft3
Funcionalidade: Novo usuário Inválido

Contexto: 
Dado que eu acesso o site e não tenho um cadastro    

Esquema do Cenário: Criar um cadastro com dados inválidos
Quando eu crio um novo cadastro com <email>, <nome>, <cpf>
Então sou direcionado a criar uma <senha1>, <senha2>
E preencho os dados de nascimento dia, mes, ano
Então verifico <resultado> dos dados inseridos

Exemplos:
| email                     | nome         | cpf           | senha1     | senha2| resultado                    |
| "graziela@gmail.com"      | "teste test" | "37305879002" | "1234567"  |  "12345678"    | "As senhas não conferem."    |

 
Esquema do Cenário: dados inválidos - Aceitar Termo
Quando eu crio um novo cadastro com <email>, <nome>, <cpf>
Então sou direcionado a criar uma <senha1>, <senha2>
E preencho os dados de nascimento dia, mes, ano, sem o termo
Então verifico <resultado> dos dados inseridos

Exemplos:
| email                     | nome         | cpf           |  senha1        | senha2         | resultado |
| "graziela@gmail.com.br"   | "teste test" | "37305879002" | "1234567"  |  "1234567"     | "Você deve aceitar os termos de uso para continuar."|


Esquema do Cenário: dados inválidos - Menor de Idade
Quando eu crio um novo cadastro com <email>, <nome>, <cpf>
Então sou direcionado a criar uma <senha1>, <senha2>
E preencho os dados de nascimento de um menor de idade
Então verifico <resultado> dos dados inseridos

Exemplos:
| email                     | nome         | cpf           |  senha1        | senha2 | resultado |
| "graziela@gmail.com.br"   | "teste test" | "37305879002" | "1234567"  |  "1234567"     | "* É necessário ter mais de 16 anos!" |

