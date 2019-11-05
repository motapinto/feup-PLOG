:- (dynamic initialBoard/1).

initialBoard([
        [r, r, b, y, n, n, n, n, n, n, n, n],
        [y, b, r, b, n, n, n, n, n, n, n, n],
        [y, y, r, y, n, n, n, n, n, n, n, n], 
        [b, r, b, y, n, n, n, n, n, n, n, n], 
        [y, y, b, r, n, n, n, n, n, n, n, n], 
        [b, r, b, y, n, n, n, n, n, n, n, n],
        [y, r, b, r, n, n, n, n, n, n, n, n], 
        [r, r, b, y, n, n, n, n, n, n, n, n], 
        [r, r, r, r, n, n, n, n, n, n, n, n], 
        [r, r, r, r, n, n, n, n, n, n, n, n], 
        [r, r, r, r, n, n, n, n, n, n, n, n]
    ]).

%   Conversion between what is stored and whats is displayed     
piece(n, -).
piece(r, 'R').
piece(y, 'Y').
piece(b, 'B').
%
printLineConst :-
    write('\n---|---|---|---|---|---|---|---|---|---|---|---|---|\n').
%
printBoardTop :-
    write('      _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n').
%
printBoardUp :-
    write('| a | b | c | d | e | f | g | h | i | j | l | m |\n ').
%

printBoardLine([], 11):-
    write('|\n').

printBoardLine([], Line) :-
    Aux is Line mod 2,
    (
        (
            Aux==0, !, write('|\n')
        )
        ;
        write('|_\n')
    ).
printBoardLine([H|T], Line) :-
    write('|_'),
    piece(H, S),
    write(S),
    write('_'),
    printBoardLine(T, Line).
%
printBoardBody([], 12).
printBoardBody([H|T], Line) :-
    (   
        (
            Line<10, !,
            write(' ')
        )
        ;  
        Line>9
    ),
    write(Line),
    write('   '),
    Mod is Line mod 2,
    (  
        (
            Mod == 0, !,
            write('  ')
        )
        ;  
        Mod == 1
    ),
    printBoardUp,
    write('    '),
    (  
        (
            Mod == 0, !,
            write(' _')
        )
        ;  
        Mod == 1
    ),
    printBoardLine(H, Line),
    LineI is Line+1,
    printBoardBody(T, LineI).
%
printBoard(X) :-
    printBoardTop,
    printBoardBody(X, 1).
%
print :-
    initialBoard(Init),
    printBoard(Init).


