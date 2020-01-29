# language: pt

@login @produto  @deslogar
Funcionalidade: Modalidade de Pagamento - Transferência Bancária

# Exceção: Expiração e reserva/disponíveis
# plugar com banco para verificar se a compra foi efetivada
# gerar créditos antes de fazer o pagamento


Esquema do Cenário: Transferência Bancária Sucesso
Dado que o usuário contenha <titulos> no carrinho
Então liberar o pagamento com transferência <titular>, <agencia>, <conta>, <digitoConta>

Exemplos:
| titulos    | titular      | agencia | conta | digitoConta|
| "5"        | "Carlos Ef"  | "1234"| "345678"| "3"|

