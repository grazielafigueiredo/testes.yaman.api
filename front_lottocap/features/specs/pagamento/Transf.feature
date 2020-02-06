# language: pt
@transf

@login @produto @deslogar 
Funcionalidade: Modalidade de Pagamento - Transferência Bancária

# Exceção: Expiração e reserva/disponíveis   

Esquema do Cenário: Transferência Bancária
Dado que o usuário apresente <titulos> no carrinho.
Então deve apresentar as seguintes <forma_pagamento_desabilitada> 

Exemplos:
| titulos    | forma_pagamento_desabilitada |
| "28"       | "" |
| "1"        | "Cartão de crédito,Boleto Bancário,Transferência bancária" |
| "6"        | "Boleto Bancário" |


# Aprovação do pagamento em até 2 horas após a sua efetivação.
# De segunda a sábado, das 9h às 19h30.
# Após o horário que o sistema estava esperando, a compra [e cancelada e o valor fica na PagVap, fazer o processo manual, 
# entrar no login do usuario e fazem a compra e acosia ao credito
# Valor depositado a mais que o sistema estava esperando, 30 depositou 50, os outros 20 é gerado uma nova compra de creditp
