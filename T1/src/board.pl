%   Asterismo is a fast cooperative abstract game for 2 or 3 players, played on an hexagonal board.
%   63 colored (blue, yellow and red) disc-shaped pieces are randomly put on the board, 
%   forming a compact tree. A piece is "safe" if is connected to at least 2 pieces of the same color, 
%   or to at least 3 pieces. The goal for each player is to collect several pieces (in a 3 players game, 
%   10 of a given color; in a 2 players game, 5 pieces of each color), while keeping every other piece safe.

initialBoard = 
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
    ].


piece(nullCell, '-').
piece(red,'R').
piece(yellow, 'Y').
piece(blue, 'B').

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
    printBoardLine(T).

%DUVIDAAAAAAAAAAAAAAAAAAAA PQ QUE COM N EM VEZ DE 12 DA ERRO?
printBoardBody([], 12).
printBoardBody([H|T], Line) :-
    
    ((   
        Line < 10,
        write(' ')
    );
    (
        Line > 9
    )),
        
    write(Line),
    write(' | '),

    





    LineI is Line + 1,

    printBoardLine(H),
    printLineConst,
    printBoardBody(T, LineI).


printBoard(X) :-
    printBoardHead,
    printBoardBody(X, 1).

print :-
    initialBoard(Init),
    printBoard(Init).