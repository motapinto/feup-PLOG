:-use_module(library(clpfd)).
:-use_module(library(lists)).

zeros(Numbers):-
    Numbers = [A, B],
    domain(Numbers, 0, 1000000000),
    A * B #= 1000000000,
    B #> A
    labeling([], Numbers).
    %restrictions(A, B).

restrictions(0, 0).
restrictions(A, B) :-
    Aaux is A mod 10,
    Baux is B mod 10,
    Aaux > 0, Baux > 0,
    restrictions(Aaux, Baux).