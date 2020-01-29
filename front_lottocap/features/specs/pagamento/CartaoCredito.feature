# language: pt

@login @produto  @deslogar
Funcionalidade: Modalidade de Pagamento - Cartão de Crédito 

# Exceção: Expiração e reserva/disponíveis   

Esquema do Cenário: Cartão de Crédito Desabilitado
Dado que o usuário possua <titulos> no carrinho.
Então deve conferir que as seguintes <forma_pagamento_desabilitada> estão desabilitadas.

Exemplos:
| titulos     | forma_pagamento_desabilitada                               | 
| "1"         | "Cartão de crédito,Transferência bancária,Boleto Bancário" | 
| "20"        | "" | 

Esquema do Cenário: Cartão de Crédito com dados de cartão inválido
Dado que o usuário possua <titulos> no carrinho.
Então liberar o pagamento com Cartão de Crédito com os dados <titular> <numCartao> <validade> <cvv> <resultado>

Exemplos:
| titulos     |  titular    | numCartao             | validade   | cvv   | resultado|
| "20"        |  "Carlos H" | "5125 6519 4821 6253" | "1111"     | "123" | "* Erro na confirmação do pagamento: 400 - Data de vencimento do cartão expirada."|
# # | "20"        |  "Carlos H" | "5125 6519 4821 6253" | "1129"     | "12"  | "* Erro na confirmação do pagamento: 400 - O campo código de segurança para a bandeira Visa deve conter 3 dígitos."|
| "20"        |  "Carlos H" | "1111 4242 4242 4242" | "1111"     | "123" | "* Número de cartão inválido"|
| "20"        |  "Carlos H" | "4242 4242 4242 4242" | ""         | "123" | "* Data inválida."|
| "20"        |  ""         | "4242 4242 4242 4242" | "1129"     | "123" | "* Campo obrigatório." |
| "20"        |  "Carlos H" | "4242 4242 4242 4242" | "1129"     | ""    | "* CVV inválido." |


