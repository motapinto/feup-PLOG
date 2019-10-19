:- dynamic tabuleiro/1, cell/3.

tabuleiro([[tb, cb, bb], [tb, cb, bb]]).

cell(1,1,tb).
cell(1,2,cb).
cell(1,3,bb).

retiraTabuleiro(Tab) :-
    retract(tabuleiro(Tab)).

guardaTabuleiro(Tab) :-
    assert(tabuleiro(Tab)).

actualizaTabuleiro :-
    retiraTabuleiro(TabIn),
    joga(TabIn, TabOut),
    guardaTabuleiro(TabOut).

joga([[_,cb,_], L], [[cb,cb,cb], L]).