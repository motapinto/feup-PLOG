%   Conversion between what is stored and displayed     
piece(0, ' ').
piece(1, 'O').
piece(2, 'M').
piece(3, 'N').
piece(4, '*').


%   Prints the top part of the board
printBoardTop(0):-
    write('\n').
printBoardTop(Counter) :-
    write(' _ _ _'),
    CounterAux is Counter - 1,
    printBoardTop(CounterAux).

%   Prints the down part of the board
printBoardDown(0):-
    write('|\n').
printBoardDown(Counter) :-
    write('|_ _ _'),
    CounterAux is Counter - 1,
    printBoardDown(CounterAux).

%  Prints the rows of the board
printBarsRows(0):-
    write('|\n').
printBarsRows(Counter):-    
    write('|     '),
    CounterAux is Counter - 1,
    printBarsRows(CounterAux).

%  Prints each line of the board line content
printBoardLine([], _):-
    write('\n').
printBoardLine([H|T], Line) :-
    piece(H, S),
    write(S),
    write('  |  '),
    printBoardLine(T, Line).
    
%   Prints the contents of a line
printBoardBody([], N, N).
printBoardBody([H|T], N, Line) :-    
    %   Iterates through the rows of the board
    printBarsRows(N),
    write('|  '),
    printBoardLine(H, Line),
    printBoardDown(N),

    LineI is Line+1,
    printBoardBody(T, N, LineI).

%   Prints the board sent in variable X
printBoard(X, N):-
    printBoardTop(N),
    printBoardBody(X, N, 0).