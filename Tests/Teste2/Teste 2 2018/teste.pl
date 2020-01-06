:- use_module(library(lists)).
:- use_module(library(between)).

prog1(N, M, L1, L2) :-
    length(L1, N),
    N1 is N-1, length(L2, N1),
    findall(E, between(1, M, E), LE),
    fill(L1, LE, LE_),
    fill(L2, LE_, _),
    check(L1, L2).

% Preenche uma lista com valores de uma outra lista
fill([], LEf, LEf).
fill([X|Xs], LE, LEf) :-
    select(X, LE, LE_),
    fill(Xs, LE_, LEf).

% Verifica se a soma de cada par consecutivo de uma lista e equivalente ao elemento de uma outra lista
% check([1, 2, 3], [3, 5]) -> yes
check([_], []).
check([A, B | R], [X|Xs]) :-
    A + B =:= X,
    check([B|R], Xs).

%  1)
%  A lista 2 tem de ter menos 1 elemento que a lista 1
%  O findall guarda na lista LE todos os valores entre 1 e M 
%  Preenche as duas lista com valores entre 1 e M
%  Verifica se a soma de cada par consecutivo de uma lista e equivalente ao elemento de uma outra lista

% 2) M^2N-1

% 3)
check1([_], []).
check1([A, B | R], [X|Xs]) :-
    A + B #= X,
    check1([B|R], Xs).


:- use_module(library(clpfd)).
prog2(N, M, L1, L2) :-
    length(L1, N),
    length(P, N),
    N1 is N-1, length(L2, N1),
    all_distinct(L1), all_distinct(L2),
    domain(L1, 1, M),
    domain(L2, 1, M),
    check1(L1, L2),
    sorting(L1, P, L1),
    labeling([], L1).
% verificar que prog2(2,4,L1,L2) nao tem simetrias e prog1(2,4,L1,L2) tem

%4)
gym_pairs(MenHeights, WomenHeights, Delta, Pairs) :-
    length(MenHeights, N), length(WomenHeights, N),
    domain(WomenIndexes, 1, N), all_distinct(WomenIndexes),
	domain(MensIndexes, 1, N), all_distinct(MensIndexes),
	

height_rule(MenHeights, WomenHeights, Delta, MIndex, WIndex, 0, 0):-
    element(MIndex, MenHeights, MElem),
    element(WIndex, WomenHeights, WElem),
    MElem #> WElem #/\ MElem - WElem #=< Delta.