:- (dynamic initialBoard/1).

if_then_else(R, P, Q) :-
    R, !, P.
if_then_else(R, P, Q) :-
    Q.


%   Conversion between what is stored and displayed     
piece(0, ' ').
piece(1, 'O').
piece(2, 'M').
piece(3, 'N').
piece(4, '*').

%   To print the top part of the board
printBoardTop :-
    write(' _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n').

printBoardDown :-
    write('|_ _ _|_ _ _|_ _ _|_ _ _|_ _ _|\n').


printBoardLine([], _):-
    write('\n').
printBoardLine([H|T], Line) :-
    piece(H, S),
    write(S),
    write('  |  '),
    printBoardLine(T, Line).
    
%   To print the contents of a line
printBoardBody([], 5).
printBoardBody([H|T], Line) :-    
   
    %   Iterates through the rows of the board
    write('|     |     |     |     |     |\n'),
    write('|  '),
    printBoardLine(H, Line),
    printBoardDown,

    LineI is Line+1,
    printBoardBody(T, LineI).


%   Prints the board sent in variable X
printBoard(X):-
    printBoardTop,
    printBoardBody(X, 1).