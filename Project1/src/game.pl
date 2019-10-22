%   include library's
:- [board].
:- [rules].



%   Starts players with player mode
startPP :-
    initialBoard(Init),
    printBoard(Init),
    write('PLayer1:\n'),
    removePieceMove(Init, Out),
    
    initialBoard(Init),
    printBoard(Init),
    write('\n\nPLayer2:\n'),
    removePieceMove(Init, Out),

    startPP.

%   Asks for user input to decide specifics of
%   the play move, specifically row and column
removePieceMove(BoardIn, BoardOut) :-
    write('> Removing piece...\n'),
    write('> Select row: '),
    read(Row), 
    write('> Select column: \n'),
    read(Column),
    
    checkMove(Row, Column),

    retract(initialBoard(Init)),
    removePiece(Init, Out, Row, Column),
    assert(initialBoard(Out)),
    printBoard(Out).

%   Checks if row, column respect board limits
checkMove(Row, Column) :-
    (
        Row > 0, Row < 12,
        Column > 0, Column < 13
    ) ; 
    write('Invalid play move\n\n'),
    removePieceMove.


%   Removes the piece from BoardIn and updates in BoardOut
removePiece(BoardIn, BoardOut, Row, Column) :-
    updateRow(Row, Column, In, Out).
%
%
updateRow(1, Column, [H|T], [Hout|T]):-
    updateColumn(Column, H, Hout).
%    
updateRow(Row, Column, [H|T], [H|Tout]):-
    Row > 1,
    RowNext is Row - 1, 
    updateRow(RowNext, Column, T, Tout).
updateColumn(1, [H|T], [Hout|T]):-
    Hout = nullCell.
%
updateColumn(Column, [H|T], [H|Tout]):-
    Column > 1,
    ColumnI is Column - 1, 
    updateColumn(ColumnI, T, Tout).
