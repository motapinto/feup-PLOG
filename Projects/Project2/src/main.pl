:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-[board].


initialBoard1(
    [   
        A, B, C, D, E, 
        E, F, G, G, H, 
        I, X, J, L, M,  
        N, O, P, Q, R,  
        S, T, U, V, W
    ]
).

main(N, L):- 
    Limit is N*N,
    %reset_timer,
    %initialBoard1(L),
    length(L, Limit),
    domain(L, 0, 4), 

    sumLines(L, N, 0), 

    labeling([], L), write(L).
    % print_time,
    % fd_statistics.


sumLines(_, LineSize, LineSize).
sumLines(Vars, LineSize, Line):-
    sumLineDots(Vars, LineSize, 0, Line, TotalSumDots),
    TotalSumDots #= 2,
    sumLineLetters(Vars, LineSize, 0, Line, TotalSumLetters),
    TotalSumLetters #= 1,
    LineAux is Line + 1,
    sumLines(Vars, LineSize, LineAux).


if_then_else(P, Q, R): P , ! , Q.
if_then_else(P, Q, R): R.


sumLineDots(_, LineSize,  LineSize, _ , 0).
sumLineDots(Vars, LineSize, Counter, Line, TotalSum):-
    CounterAux is Counter + 1,
    sumLineDots(Vars, LineSize, CounterAux, Line, TotalSumAux),
    Index is LineSize * Line + Counter,
    nth0(Index, Vars, Elem),
    Elem #= 4 #<=> B,
    TotalSum #= TotalSumAux + B.

sumLineLetters(_, LineSize,  LineSize, _ , 0).
sumLineLetters(Vars, LineSize, Counter, Line, TotalSum):-
    CounterAux is Counter + 1,
    sumLineLetters(Vars, LineSize, CounterAux, Line, TotalSumAux),
    Index is LineSize * Line + Counter,
    nth0(Index, Vars, Elem),
    (Elem #> 0 #/\  Elem #< 4) #<=> B,
    TotalSum #= TotalSumAux + B.


sumColumns(_, ColumnSize, ColumnSize, _).
sumColumns(Vars, ColumnSize, Column, TotalSum):-
    sumColumn(Vars, ColumnSize, 0, Column, TotalSum),
    ColumnAux is Column + 1,
    sumColumns(Vars, ColumnSize, ColumnAux, TotalSum).


sumColumnDots(_, ColumnSize,  ColumnSize, _ , 0).
sumColumnDots(Vars, ColumnSize, Counter, Column, TotalSum):-
    CounterAux is Counter + 1,
    sumColumnDots(Vars, ColumnSize, CounterAux, Column, TotalSumAux),
    Index is ColumnSize * Counter + Column,
    nth0(Index, Vars, Elem),
    Elem #= 4 -> TotalSum #= TotalSumAux + 1 ; TotalSum #= TotalSumAux.



reset_timer:- statistics(walltime,_).

print_time:-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
  nl, write('Solution Time: '), write(TS), write('s'), nl, nl.