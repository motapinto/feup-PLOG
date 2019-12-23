:-use_module(library(clpfd)).

kid(L, M) :-
    % Vars = [A, B, C],
    % table([[A,B],[B,C]],[[1,1],[1,2],[2,10],[2,20]]),
    % labeling([], Vars).
    length(L,5),
    domain(L,1,5), circuit(L, M),
    labeling([],L).
    
place(Starts) :-
    Starts = [A, B, C],
    domain(Starts, 1, 10),
    Lines = [
    line(A, 5),
    line(B, 7),
    line(C, 3)
    ],
    A #< C,
    disjoint1(Lines),
    labeling([], Starts).

chain(L):-
    length(L,3), 
    domain(L, 1, 3),
    value_precede_chain([3,2,1], L),
    labeling([], L).
    
    

