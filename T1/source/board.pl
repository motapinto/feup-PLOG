%   Asterismo is a fast cooperative abstract game for 2 or 3 players, played on an hexagonal board.
%   63 colored (blue, yellow and red) disc-shaped pieces are randomly put on the board, 
%   forming a compact tree. A piece is "safe" if is connected to at least 2 pieces of the same color, 
%   or to at least 3 pieces. The goal for each player is to collect several pieces (in a 3 players game, 
%   10 of a given color; in a 2 players game, 5 pieces of each color), while keeping every other piece safe.

initialBoard(
    [
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ],
        [ nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell, nullCell ]
    ]
).

piece(nullCell, S) :- S ='-'.
piece(red, S) :- S ='R'.
piece(yellow, S) :- S ='Y'.
piece(blue, S) :- S ='B'.
    

printBoardHead :-
    write('   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10| 11| 12|'),
    printLineConst.

printLineConst :-
    write('\n---|---|---|---|---|---|---|---|---|---|---|---|---|\n').
    
printLine([]).
printLine([H|T]) :-
    piece(H, S),
    write(S),
    write(' | '),
    printLine(T).

printBoardBody([]).
printBoardBody([H|T], N) :-
    write(' '),
    write(N),
    write(' | '),

    Ni is N + 1,
    Ni < 13,

    printLine(H),
    printLineConst,
    printBoardBody(T, Ni).

printBoard(X) :-
    printBoardHead,
    printBoardBody(X, 1).
    printBoardHeader(1).