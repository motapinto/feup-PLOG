:- (dynamic initialBoard/1).

if_then_else(R, P, Q) :-
    R, !, P.
if_then_else(R, P, Q) :-
    Q.

%   Initial Configuration of Board
initialBoard([
    [ n, n, n, n, n],
    [ n, n, n, n, n],
    [ n, n, n, n, n], 
    [ n, n, n, n, n], 
    [ n, n, n, n, n]
]).

%   Conversion between what is stored and displayed     
piece(n, -).
piece(r, 'R').
piece(y, 'Y').
piece(b, 'B').

%   To print the top part of the board
printBoardTop :-
    write('_____________________\n'),
    write('|   |   |   |   |   |\n').

%   To print the contents of a line and prints the score of the players on the side 
printBoardLine([], 5):-
    write('|\n').

printBoardLine([], Line) :-
    write('|'), write('\n').

printBoardLine([H|T], Line) :-
    write('|_'),
    piece(H, S),
    write(S),
    write('_'),
    printBoardLine(T, Line).
    
%   To print the contents of a line
printBoardBody([], 5).
printBoardBody([H|T], Line) :-    

    %   Iterates through the rows of the board
    printBoardLine(H, Line),
    LineI is Line+1,
    printBoardBody(T, LineI).

%   Prints the current Board
printBoard:-
    initialBoard(Init),
    printBoardTop,
    printBoardBody(Init, 1), !.

%   Prints the board sent in variable X
printBoard(X):-
    printBoardTop,
    printBoardBody(X, 1).