:-[data].
:-use_module(library(clpfd)).

%   [1, StarttIME, eNDtIME]

main(L) :- 
    L = [
            [Id0, Start0, Start1],
            [],
            []
        ],
    domain(L, 0, 2), % equivalente a fazer L in 0..2
    WA #\= NT, WA#\=SA,
    NT #\=NT, NT#\=Q,
    write('.'), %ver quantas vezes faz p backtracking -> so imprime uma vez o '.'
    labeling([], L). 