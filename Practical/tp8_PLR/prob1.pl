:-use_module(library(clpfd)).
:-use_module(library(lists)).

% 3 by 3 version
magic(Vars) :-
    Vars = [A1, A2, A3, A4, A5, A6, A7, A8, A9], 
    domain(Vars,  1,  9), 

    all_distinct(Vars), 

    A1 + A2 + A3 #= Soma, 
    A4 + A5 + A6 #= Soma, 
    A7 + A8 + A9 #= Soma, 
    A1 + A4 + A7 #= Soma, 
    A2 + A5 + A8 #= Soma, 
    A3 + A6 + A9 #= Soma, 
    A1 + A5 + A9 #= Soma, 
    A3 + A5 + A7 #= Soma, 
    
    % Eliminar simetrias
    A1 #< A2, 
    A1 #< A3,  
    A1 #< A4,  
    A2 #< A4,

    labeling([], Vars).

% N by N version
magic(N, Vars) :-
    Limit is N*N,
    length(Vars, Limit),
    domain(Vars, 1, Limit),
    all_distinct(Vars),
    
    sumLines(Vars, N, 0, Soma), 
    sumColumns(Vars, N, 0, Soma),
    sumDiagonal1(Vars, N, 0, Soma),
    sumDiagonal2(Vars, N, 0, Soma), 
    
    labeling([], Vars).

sumLines(_, LineSize, LineSize, _).
sumLines(Vars, LineSize, Line, TotalSum):-
    sumLine(Vars, LineSize, 0, Line, TotalSum),
    LineAux is Line + 1,
    sumLines(Vars, LineSize, LineAux, TotalSum).


sumLine(_, LineSize,  LineSize, _ , 0).
sumLine(Vars, LineSize, Counter, Line, TotalSum):-
    CounterAux is Counter + 1,
    sumLine(Vars, LineSize, CounterAux, Line, TotalSumAux),
    Index is LineSize * Line + Counter,
    nth0(Index, Vars, Elem),
    TotalSum #= TotalSumAux + Elem.


sumColumns(_, ColumnSize, ColumnSize, _).
sumColumns(Vars, ColumnSize, Column, TotalSum):-
    sumColumn(Vars, ColumnSize, 0, Column, TotalSum),
    ColumnAux is Column + 1,
    sumColumns(Vars, ColumnSize, ColumnAux, TotalSum).


sumColumn(_, ColumnSize,  ColumnSize, _ , 0).
sumColumn(Vars, ColumnSize, Counter, Column, TotalSum):-
    CounterAux is Counter + 1,
    sumColumn(Vars, ColumnSize, CounterAux, Column, TotalSumAux),
    Index is ColumnSize * Counter + Column,
    nth0(Index, Vars, Elem),
    TotalSum #= TotalSumAux + Elem.

sumDiagonal1(_, DiagonalSize, DiagonalSize, 0).
sumDiagonal1(Vars, DiagonalSize, Counter, TotalSum):-
    CounterAux is Counter + 1,
    sumDiagonal1(Vars, DiagonalSize, CounterAux, TotalSumAux),
    Index is DiagonalSize * Counter + Counter,
    nth0(Index, Vars, Elem),
    TotalSum #= TotalSumAux + Elem.

sumDiagonal2(_, DiagonalSize,  DiagonalSize, 0).
sumDiagonal2(Vars, DiagonalSize, Counter, TotalSum):-
    CounterAux is Counter + 1,
    sumDiagonal2(Vars, DiagonalSize, CounterAux, TotalSumAux),
    Index is (DiagonalSize - 1) * (Counter + 1),
    nth0(Index, Vars, Elem),
    TotalSum #= TotalSumAux + Elem.



