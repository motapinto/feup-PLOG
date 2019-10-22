%   include library's
:- [board].
:- [rules].



%   Starts players with player mode
startPP :-
    initGame(Init),
    playLoop.

%   Randomizes initial Board and prints it
initGame(Init) :-
    initialBoard(Init),
    printBoard(Init).

%   Loop of playing
playLoop :-
    write('Player1:\n'),
    removePieceAsk(Init, Out),
    
    initialBoard(Init),
    
    write('\n\nPlayer2:\n'),
    removePieceMove(Init, Out),

    playLoop.
%   Asks for user input to decide specifics of
%   the play move, specifically row and column
removePieceAsk(BoardIn, BoardOut) :-
    write('> Removing piece...\n'),
    write('> Select row: '),
    read(Row), 
    write('> Select column: '),
    read(Column),
    
    checkMove(Row, Column, BoardIn, BoardOut),
    removePieceDo(BoardIn, BoardOut).

removePieceDo(BoardIn, BoardOut) :-

    retract(initialBoard(Init)),
    removePiece(Init, Out, Row, Column),
    assert(initialBoard(Out)),
    printBoard(Out).

%   Checks if row, column respect board limits
checkMove(Row, Column, In, Out) :-
    (
        Row > 0, Row < 12,
        Column > 0, Column < 13
    ) ; 
    write('Invalid row and/or column\n\n'),
    removePieceAsk(In, Out).

%   Removes the piece from BoardIn and updates in BoardOut
removePiece(BoardIn, BoardOut, Row, Column) :-
    updateRow(Row, Column, BoardIn, BoardOut).

updateColumn(1, [H|T], [Hout|T]):-
    Hout = nullCell.
%
updateColumn(Column, [H|T], [H|Tout]):-
    Column > 1,
    ColumnI is Column - 1, 
    atualizaColuna(ColumnI, T, Tout).
%
updateRow(1, Column, [H|T], [Hout|T]):-
    updateColumn(Column, H, Hout).
%    
updateRow(Row, Column, [H|T], [H|Tout]):-
    Row > 1,
    RowNext is Row - 1, 
    updateRow(RowNext, Column, T, Tout).