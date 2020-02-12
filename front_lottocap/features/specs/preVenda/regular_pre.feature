# language: pt
@regular_pre

Funcionalidade: comprar com max regular e pré venda

@login 
@deslogar

Esquema do Cenário:
Dado que adiciono um max regular no carrinho e um pré venda
Quando vou confirmar se as opcões <forma_pagamento_desabilitada> estao bloqueadas
Então compro os títulos no cartão de crédito

Exemplos:
| forma_pagamento_desabilitada | 
| "Transferência bancária,Boleto Bancário" |

