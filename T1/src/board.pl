%   Asterismo is a fast cooperative abstract game for 2 or 3 players, played on an hexagonal board.
%   63 colored (blue, yellow and red) disc-shaped pieces are randomly put on the board, 
%   forming a compact tree. A piece is "safe" if is connected to at least 2 pieces of the same color, 
%   or to at least 3 pieces. The goal for each player is to collect several pieces (in a 3 players game, 
%   10 of a given color; in a 2 players game, 5 pieces of each color), while keeping every other piece safe.

initialBoard = 
    [
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ]
    ].


piece(nullCell, S) :- S ='-'.
piece(red, S) :- S ='R'.
piece(yellow, S) :- S ='Y'.
piece(blue, S) :- S ='B'.

printBoardHead :-
    write('   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12|'),
    printLineConst.

printLineConst :-
    write('\n---|---|---|---|---|---|---|---|---|---|---|---|---|\n').
    
printBoardLine([]).
printBoardLine([H|T]) :-
    piece(H, S),
    write(S),
    write(' | '),

    printBoardLine(X).

%DUVIDAAAAAAAAAAAAAAAAAAAA PQ QUE COM N EM VEZ DE 12 DA ERRO?
printBoardBody([], 12).
printBoardBody([H|T], N) :-
    N<10,
    write(' '),
    write(N),

    Ni is N + 1,

    printBoardLine1(H),
    printBoardLine2(T),
    printLineConst,
    printBoardBody(T, Ni)

    ;

    N>9,
    write(N),
    write(' | '),

    Ni is N + 1,

    printBoardLine1(H),
    printBoardLine2(T),
    printLineConst,
    printBoardBody(T, Ni).

printBoard(X) :-
    printBoardHead,
    printBoardBody(X, 1).

print :-
    printBoard(initialBoard).

printBoardLine1([]).
printBoardLine1([H|T]) :-
    write(' | '),
    piece(H, S),
    write(S),
    write(' | '),

    printBoardLine1(X).

printBoardLine2([]).
printBoardLine2([H|T]) :-
    write('  | '),
    piece(H, S),
    write(S),
    write(' | '),

    printBoardLine2(X).