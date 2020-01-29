# language: pt

@login @produto   @deslogar  @py
Funcionalidade: Modalidade de Pagamento - Crédito Lottocap

# Exceção: Expiração e reserva/disponíveis
# plugar com banco para verificar se a compra foi efetivada
# gerar créditos antes de fazer o pagamento


Esquema do Cenário: Crédito Lottocap sucesso
Dado que o usuário disponha de <titulos> no carrinho
Então liberar o pagamento com crédito lottocap

Exemplos:
| titulos    | forma_pagamento_desabilitada |
| "1"        | "Cartão de crédito,Boleto Bancário,Transferência bancária" |

