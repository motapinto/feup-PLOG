comprou(joao, honda).
comprou(joao, uno).

ano(honda, 2010). 
ano(uno, 2011).

valor(honda, 10000).
valor(uno, 7000). 

podeVender(Pessoa, Carro, Ano) :- 
    comprou(Pessoa, Carro), 
    valor(Carro, X), X =@= 10000, 
    ano(Carro, Y), Y > 2009, Y < 2019. 
