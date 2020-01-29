# language: pt

@loginboleto  @produto @deslogar @a
Funcionalidade: Modalidade de Pagamento - Cartão de Crédito 

# Exceção: Expiração e reserva/disponíveis   

Esquema do Cenário: Cartão de Crédito
Dado que o usuário possua <titulos> no carrinho
E liberar o pagamento com Cartão de Crédito com os dados <titular>, <numCartao>, <validade>, <cvv>

Exemplos:
| titulos     |  titular    | numCartao             | validade   | cvv   | 
| "20"        |  "Carlos H" | "4000000000000010" | "1120"     | "123" | 
