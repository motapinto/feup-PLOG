%   Asterismo is a fast cooperative abstract game for 2 or 3 players, played on an hexagonal board.
%   63 colored (blue, yellow and red) disc-shaped pieces are randomly put on the board, 
%   forming a compact tree. A piece is "safe" if is connected to at least 2 pieces of the same color, 
%   or to at least 3 pieces. The goal for each player is to collect several pieces (in a 3 players game, 
%   10 of a given color; in a 2 players game, 5 pieces of each color), while keeping every other piece safe.

:- dynamic initialBoard/0.

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
    


piece(nullCell, '-').
piece(red,'R').
piece(yellow, 'Y').
piece(blue, 'B').


printLineConst :-
    write('\n---|---|---|---|---|---|---|---|---|---|---|---|---|\n').

printBoardTop:-
    write('      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n').


printBoardUp:-
    write('| a | b | c | d | e | f | g | h | i | j | l | m |\n ').


printBoardLine([], Line ):-
    (Line == 12,
    write('|\n'));
    (Aux is Line mod 2,
    Aux == 0,
    write('|_\n'));
    write('|\n').

printBoardLine([H|T] , Line) :-
    write('|_'),
    piece(H, S),
    write(S),
    write('_'),
    printBoardLine(T, Line).

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
        write('   '),
        
    Mod is Line mod 2,
    
    (((Mod == 0), 
        write('  ')
    );
    (
      Mod==1
    )),

    printBoardUp,
    write('    '),
    (((Mod == 0), write(' _'));
    (Mod==1
    )),
    LineI is Line + 1,
    printBoardLine(H, LineI),
    printBoardBody(T, LineI).


printBoard(X) :-
    printBoardTop,
    printBoardBody(X, 1).

print :-
    initialBoard(Init),
    printBoard(Init).