:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-[board].

countNumberOfPiecesRow(L, Line, Size, NumOfPoints, NumOfLetters).


countNumberOfPiecesColumn(L, Column, Size, NumOfPoints, NumOfLetters).

initialBoard1(
    [   
        A, B, C, D, 1, 
        E, F, 3, G, H, 
        I, 1, J, L, M,  
        N, O, P, Q, R,  
        S, T, U, V, W
    ]
).

main(L):- 
    reset_timer,
    initialBoard1(L),
    domain(L, 0, 4),

    (
        A == 4, (B == 4 ; C==4; D==4)


    labeling([], L),   
    write(L),
    print_time,
    fd_statistics.


reset_timer:- statistics(walltime,_).

print_time:-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
  nl, write('Solution Time: '), write(TS), write('s'), nl, nl.