    # language: pt

@login @produto @deslogar
Funcionalidade: Modalidade de Pagamento - Boleto 

# Exceção: Expiração e reserva/disponíveis   
# plugar com banco para verificar se a compra foi efetivada
# gerar créditos antes de fazer o pagamento
# confirma se a comprar em 3 dias, 
# confirmar a compra dentro do horario comercial até as 19h de brasilia

Esquema do Cenário: Boleto sucesso
Dado que o usuário tenha <titulos> no carrinho
Então liberar o pagamento com boleto e <resultado> da confirmação

Exemplos:
| titulos    | resultado |
| "28"       | "ATENÇÃO: Confirmação em até 3 dias."|

