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


printBoardLine(_, N, _, N):-
    write('\n').
printBoardLine(Vars, N, Line, Counter) :-
    Index is N * Line + Counter,
    nth0(Index, Vars, Element),
    piece(Element, S),
    write(S),
    write('  |  '),
    CounterAux is Counter + 1,
    printBoardLine(Vars, N,  Line, CounterAux).
    
%   To print the contents of a line
printBoardBody(_, N, N).
printBoardBody(Vars, N, Line) :-    
    %   Iterates through the rows of the board
    write('|     |     |     |     |     |\n'),
    write('|  '),
    printBoardLine(Vars, N, Line, 0),
    printBoardDown,
    LineI is Line+1,
    printBoardBody(Vars, N, LineI).


%   Prints the board sent in variable X
printBoard(X , N):-
    printBoardTop,
    printBoardBody(X, N, 0).