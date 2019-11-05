:- [board].

:- (dynamic counterEq/1).
:- (dynamic counterDif/1).

% CHANGE checkIfPieceIsSafe

counterEq(0).
counterDif(0).

%   Checks all the rules
checkRules(Row, Column, ErrorType) :-
    checkIfNotNull(Row, Column, NullError),
    %   If the piece in specified position is not null
    (
        NullError == 0, !,
        checkIfPiecesAreSafe(Row, Column, ErrorType2),
        ErrorType = ErrorType2
    )
    ;
    %   If the piece in specified position is null
    (
        ErrorType = NullError
    ).

%   Checks if each of adjacent pieces of piece specified by it's row and column is safe
checkIfPiecesAreSafe(Row, Column, ErrorType) :-
    %   Removes the piece in specified position to see the consequences of this move
    retract(initialBoard(BoardIn)),
    removePiece(BoardIn, BoardOut, Row, Column, _),
    assert(initialBoard(BoardIn)),
    %   Checks if all 6 possible adjacent pieces are safe
    PreviousRow is Row - 1,
    NextRow is Row + 1,
    PreviousColumn is Column - 1,
    NextColumn is Column + 1,
    (
        (
            checkIfPieceIsSafe(PreviousRow, Column, BoardOut),
            checkIfPieceIsSafe(PreviousRow, NextColumn, BoardOut),
            checkIfPieceIsSafe(Row, PreviousColumn, BoardOut),
            checkIfPieceIsSafe(Row, NextColumn, BoardOut),
            checkIfPieceIsSafe(NextRow, Column, BoardOut),
            checkIfPieceIsSafe(NextRow, NextColumn, BoardOut),
            ErrorType = 0, !
        ) 
        ;
        (
            ErrorType = 2
        ) 
    ).

    
%   For each adjacent pieces checks if it is connected to 2 pieces of same color or any 3 pieces
checkIfPieceIsSafe(Row, Column, Board) :-
    (
        (Row > 0, Row < 12, 
        Column > 0, Column < 13) -> (
            %verifica se a peça é null
            checkIfNotNullAdjacent(Row, Column, Board, ErrorType),
            ( ErrorType == 1 -> true; 
                %verifica se as peças adjacentes das peças não null
                (
                        PreviousRow is Row - 1,
                        NextRow is Row + 1,
                        PreviousColumn is Column - 1,
                        NextColumn is Column + 1,
                        (
                            returnColorPiece(Row, Column, Board, Color),
                            initCounters,
                            checkAdjacentPiece(PreviousRow, Column, Board, Color),
                            checkAdjacentPiece(PreviousRow, NextColumn, Board, Color),
                            (
                                    counterEq(PiecesEq),
                                    PiecesEq == 2 -> true ; (
                                    checkAdjacentPiece(Row, PreviousColumn, Board, Color),
                                    counterEq(PiecesEq1),counterDif(PiecesDif),
                                    ((PiecesEq1 == 2 ; PiecesDif == 3) -> true ; (
                                        checkAdjacentPiece(Row, NextColumn, Board, Color),
                                        counterEq(PiecesEq2),counterDif(PiecesDif1),
                                        ((PiecesEq2 == 2 ; PiecesDif1 == 3) -> true ; (
                                            checkAdjacentPiece(NextRow, Column, Board, Color),
                                            counterEq(PiecesEq3),counterDif(PiecesDif2),
                                            ((PiecesEq3 == 2 ; PiecesDif2 == 3) -> true ; (
                                                checkAdjacentPiece(NextRow, NextColumn, Board, Color), !,
                                                counterEq(PiecesEq4),counterDif(PiecesDif3), !,
                                                ((PiecesEq4 == 2 ; PiecesDif3 == 3) -> true ; ( 
                                                    fail
                                                ))
                                            ))
                                        ))
                                    ))
                                )
                            )
                        )
                )
            )
        ); true
    ).
%   Checks which pieces are to add to addEq or addDif counters
checkAdjacentPiece(Row, Column, Board, Color) :-
    (
        (
            Row > 0, Row < 12, 
            Column > 0, Column < 13,
            returnColorPiece(Row, Column, Board, ColorAdj),
            ColorAdj \= nullCell, addDif, 
            ColorAdj == Color, addEq
        ) 
        ; 
        true  
    ).
%   Inicializes counter of equal adjacent pieces and any adjacent pieces
initCounters :-
    retract(counterEq(PiecesEq)),
    PiecesEq1 = 0,
    assert(counterEq(PiecesEq1)),

    retract(counterDif(PiecesDif)),
    PiecesDif1 = 0,
    assert(counterDif(PiecesDif1)).
%   Counts number of equal adjacent pieces
addEq :-
    retract(counterEq(PiecesEq)),
    PiecesEq1 is PiecesEq + 1,
    assert(counterEq(PiecesEq1)).
%   Counts number of any adjacent pieces
addDif :-
    retract(counterDif(PiecesDif)),
    PiecesDif1 is PiecesDif + 1,
    assert(counterDif(PiecesDif1)).
%   Checks if piece specified by it's row and column is null and if so ErrorType = 1
checkIfNotNullAdjacent(Row, Column, Board, ErrorType) :-
    checkRow(Row, Column, Board, ErrorType).
%   Checks if piece specified by it's row and column is null and if so ErrorType = 1
checkIfNotNull(Row, Column, ErrorType) :-
    initialBoard(In),
    checkRow(Row, Column, In, ErrorType).
%  When it reaches the specified column if cell is nullCell then ErrorType = 1
checkColumn(1, [H|T], ErrorType) :-
    !,
    (
        (
            H == nullCell,
            ErrorType = 1    
        )
        ;
        ErrorType = 0
    ).
%  Search the board until it finds the specified column
checkColumn(Column, [H|T] , ErrorType) :-
    Column > 1,
    ColumnI is Column - 1, 
    checkColumn(ColumnI, T, ErrorType).
%  When it reaches the specified row searches by column
checkRow(1, Column, [H|T], ErrorType) :-
    checkColumn(Column, H, ErrorType), !.
%  Search the board until it finds the specified row
checkRow(Row, Column, [H|T] , ErrorType) :-
    Row > 1,
    RowNext is Row - 1, 
    checkRow(RowNext, Column, T, ErrorType).