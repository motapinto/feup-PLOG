pessoa(ana).
pessoa(bruno).
pessoa(antonio).
pessoa(barbara).

casados(ana, bruno).

combina(salmao, vinho_maduro).
combina(peru, vinho_verde).

comida(solha).
comida(salmao).
comida(peru).
comida(frango).

bebida(cerveja).
bebida(vinho_verde).
bebida(vinho_maduro).

gosta(ana, vinho_verde).
gosta(bruno, vinho_verde).

p1(P1, P2) :- 
    casados(P1, P2),
    gosta(P1, vinho_verde),
    gosta(P2, vinho_verde).

p2(Bebida) :-
    combina(salmao, Bebida).

p3(Comida) :-
    combina(Comida, vinho_verde).