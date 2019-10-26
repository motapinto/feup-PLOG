%include library's
:- [board].
:- [rules].


%   Checks if a piece specified in Row and Column 
%   can be removed in the board game and if so remove piece
removePiece(BoardIn, BoardOut, Row, Column) :-
    atualizaLinha(Row, Column, In, Out),
    checkRules(Row, Column, In).

%   Asks for user input to decide specifics of
%   the play move, specifically row and column
removePieceMove(BoardIn, BoardOut) :-
    write('> Removing piece...\n'),
    write('> Select row: '),
    read(Row), 
    write('> Select column: \n'),
    read(Column),
    
    %   Checks if a piece specified in Row and Column 
    %   can be added in the board game and if so add piece
    checkMove(Row, Column),

    retract(initialBoard(Init)),
    removePiece(Init, Out, Row, Column),
    assert(initialBoard(Out)),
    printBoard(Out).

%   Checks if row, column and piece respect board 
%   limits and piece existance
checkMove(Row, Column) :-
    (
        Row > 0, Row < 12,
        Column > 0, Column < 13
    ) ; 
    write('Invalid play move\n\n'),
    selectMove.

%   Starts players vs player mode
startPP :-
    initialBoard(Init),
    printBoard(Init),
    write('PLayer1:\n'),
    removePieceMove(Init, Out),
    
    initialBoard(Init),
    printBoard(Init),
    write('\n\nPLayer2:\n'),
    removePieceMove(Init, Out).


atualizaColuna(1, [H|T], [Hout|T]):-
    Hout = nullCell.

atualizaColuna(Column, [H|T], [H|Tout]):-
    Column > 1,
    ColumnI is Column - 1, 
    atualizaColuna(ColumnI, T, Tout).

atualizaLinha(1, Column, [H|T], [Hout|T]):-
    atualizaColuna(Column, H, Hout).
    
atualizaLinha(Row, Column, [H|T], [H|Tout]):-
    Row > 1,
    RowNext is Row - 1, 
    atualizaLinha(RowNext, Column, T, Tout).
