:-use_module(library(clpfd)).

% 4 by 4 version
nQueens(Rows) :-
    %   Each position of Rows represent a row (Row[0] -> column position of queen for row = 0)
    Rows = [Col1, Col2, Col3, Col4],
    domain(Rows, 1, 4),

    all_distinct(Rows),
    Col2 #\= Col1 - 1,  Col2 #\= Col1 + 1, Col3 #\= Col1 - 2, Col3 #\= Col1 + 2, Col4 #\= Col1 - 3, Col4 #\= Col1 + 3,
    Col3 #\= Col2 - 1,  Col3 #\= Col2 + 1, Col3 #\= Col2 - 2, Col3 #\= Col2 + 2,
    Col4 #\= Col3 - 1,  Col4 #\= Col3 + 1,

    labeling([], Rows).

% N by N version
queens(N, Rows) :-
     %   Each position of Rows represent a row (Row[0] -> column position of queen for row = 0)
     length(Rows, N),
     domain(Rows, 1, N),
     restrictions(Rows),
     all_distinct(Rows),
     labeling([], Rows).

restrictions([]).
restrictions([H|T]) :-
    step(H, T, 1),
    restrictions(T).

step(_, [], _).
step(Col1, [Col2|T], K) :-
    verify(Col1, Col2, K),
    Kn is K + 1,
    step(Col1, T, Kn).

verify(Col1, Col2, K) :-
    Col2 #\= Col1,
    Col2 #\= Col1 - K,  
    Col2 #\= Col1 + K.