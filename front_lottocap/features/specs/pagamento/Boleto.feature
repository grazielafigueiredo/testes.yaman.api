    # language: pt

@login @produto @deslogar @boleto 
Funcionalidade: Modalidade de Pagamento - Boleto 

# Exceção: Expiração e reserva/disponíveis   
# plugar com banco para verificar se a compra foi efetivada
# gerar créditos antes de fazer o pagamento
# confirma se a comprar em 3 dias, 
# confirmar a compra dentro do horario comercial até as 19h de brasilia

Esquema do Cenário: 
Dado que o usuário tenha <titulos> no carrinho.
Então deve verificar que as seguintes <forma_pagamento_desabilitada> estão desabilitadas.


Exemplos:
| titulos    | forma_pagamento_desabilitada | 
| "2"        | "Cartão de crédito,Boleto Bancário,Transferência bancária" |
| "28"       | "" | 



