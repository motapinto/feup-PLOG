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
]).

piece(nullCell, S) :- S ='-'.
piece(red, S) :- S ='R'.
piece(yellow, S) :- S ='Y'.
piece(blue, S) :- S ='B'.

printBoardHead(N, N) :-
    write('---|'),
    Ni is N - 1,
    printBoardHead(Ni, Ni);
    write('|\n').

printBoardHead(Columns, N) :-
    format('| ~d ', N),
    Ni is N + 1,
    Columns > Ni,
    printBoardHead(Columns, Ni) ; 
    write('|\n').

printLine([]).
printLine([H|T]) :-
    symbol(H, S),
    write(S),
    write(' | '),
    printLine(T).

printBoardBody([]).
printBoardBody([H|T]) :-
    write(' '),
    write(N),
    write(' | '),

    N is N + 1,

    printLine(H),
    printBoardHead(Line, Line),
    printBoardBody(T, N).

printBoard(X) :-
    printBoardHead(13, 1),
    printBoardBody(X).
