#language: pt

Funcionalidade: 
    Validar operações da API

    @get
    Cenário: Validar método GET
    Quando faço uma requisição GET para o serviço
    Então o serviço deve responder com status code 200
    E retornar name da estrutura list