# language: pt

@login @deslogar 

@payment
Funcionalidade: Modalidade de Pagamento - Crédito Lottocap

# Exceção: Expiração e reserva/disponíveis
# plugar com banco para verificar se a compra foi efetivada
# gerar créditos antes de fazer o pagamento


Esquema do Cenário: Crédito Lottocap inválido
Dado que o usuário disponha de <titulos> no carrinho.
Então deve analisar que as seguintes <forma_pagamento_desabilitada> estão desabilitadas.

Exemplos:
| titulos    | forma_pagamento_desabilitada |
| "19"       | "" |
| "1"        | "Cartão de crédito,Boleto Bancário,Transferência bancária" |
| "6"        | "Boleto Bancário" |

