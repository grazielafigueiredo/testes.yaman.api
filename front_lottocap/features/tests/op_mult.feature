# language: pt

7. Mostrar o resultado quando executar uma operação de multiplicação. 


User Story: 	Eu, como cliente 
			 	quero realizar uma operação de multiplicação com números inteiros e pares
			 	pois o cliente necessito de uma facilidade para  obter o resultado 


Funcionalidade:  Executar operação de multiplicação
Eu, como cliente 
Quero realizar uma operação de multiplicação com números inteiros e pares de 2 a 10
Para  obter o resultado da multiplicação  

Contexto: 
Dado que eu esteja logado


Esquema do cenário:  Com dois números inteiros e pares de 2 a 10
Quando eu insiro <numero1> 
E multiplico com o <numero2>
Então tenho <resultado>
E a mensagem  <mensagem> 

numero1 | numero2  | resultado    | mensagem 
2		  |		2		|       	4 		|   Sucesso 
4		  |   	 	2		| 		8		|   Sucesso
6		  |    	4		| 		24		|   Sucesso
10		  |    	8		| 		80		|   Sucesso



Esquema do cenário:  Com dados inválidos 
Quando eu insiro <numero1> 
E multiplico com o <numero2>
Então será exibida a mensagem <mensagem> 

numero1 | numero2  |  mensagem 
-2		  |   	 	2		|  Dado inválido
3		  |    	2		|  Dado inválido
0.2		  |    	2		|  Dado inválido
String	  |    	2		|  Dado inválido
Vazio	  |    Vazio		|  Dado inválido
2		  |   	 Vazio		|  Dado inválido
2		  |   		 .-;		|  Dado inválido
12		  |    	2		|  Dado inválido




