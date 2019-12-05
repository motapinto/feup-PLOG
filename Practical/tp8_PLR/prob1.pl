:-use_module(library(clpfd)).
:-use_module(library(lists)).

magic(N, V):-
    Size is N*N,
    length(V, Size),
    domain(V, 1, Size),
    all_distinct(V),
    createMatrix(N, N, V, M),
    sumEq(M, Value),
    sumDiag(M, Value),
    transpose(M, NewM),
    sumEq(NewM, Value),
    reverseAll(M, DiagM),
    sumDiag(DiagM, Value),
    Right is N - 1,
    Left is N * (N - 1),
    iterate(V, 0, A1),
    iterate(V, Right, A2),
    iterate(V, Left, A3),
    A1 #< A2,
    A1 #< A3,
    A2 #< A3,
    labeling([], V).

createMatrix(_, 0, _, []).
createMatrix(N, CurN, Values, [Line | Matrix]):-
    CurN > 0,
    NextN is CurN - 1,
    getLineSize(N, Values, Line, NewValues),
    createMatrix(N, NextN, NewValues, Matrix).
    
getLineSize(0, List, [], List).
getLineSize(N, [Head | Tail], [Head | Line], NewList):-
    N > 0,
    NextN is N - 1,
    getLineSize(NextN, Tail, Line, NewList).

reverseAll([], []).
reverseAll([Head | Tail], [Rev | RevRet]):-
    reverse(Head, Rev),
    reverseAll(Tail, RevRet), !.

sumEq([], _Value).
sumEq([Line | OtherLines], Value):-
    sum(Line, #=, Value),
    sumEq(OtherLines, Value).

sumDiag(M, Value):- 
    valsDiag(M, 0, Diag),
    sum(Diag, #=, Value).

valsDiag(M, Coord, [Elem | Diag]):-
    getCoords(M, Coord, Coord, Elem),
    NextCoord is Coord + 1,
    !, valsDiag(M, NextCoord, Diag).
valsDiag(_M, _Coord, []).
getCoords(M, X, Y, Elem):-
    iterate(M, Y, Line), !,
    iterate(Line, X, Elem).

iterate([Head | _Tail], 0, Head).
iterate([_ | Tail], Coord, Val):-
    Coord > 0,
    NextCoord is Coord - 1,
    iterate(Tail, NextCoord, Val).



    