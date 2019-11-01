:- [board].

:- (dynamic counterEq/1).
:- (dynamic counterDif/1).

counterEq(0).
counterDif(0).

checkRules(Row, Column, ErrorType):-
    checkIfNotNull(Row, Column, ErrorType1),
    ErrorType1 == 0 -> (
            checkIfPiecesAreSafe(Row, Column, ErrorType2),
            ErrorType = ErrorType2
    ) ; (ErrorType = ErrorType1).

checkIfPiecesAreSafe(Row, Column, ErrorType):-
    retract(initialBoard(BoardIn)),
    removePiece(BoardIn, BoardOut, Row, Column, _),
    assert(initialBoard(BoardIn)),
    PreviousRow is Row - 1,
    NextRow is Row + 1,
    PreviousColumn is Column - 1,
    NextColumn is Column + 1,
    (
        (
            checkIfPieceIsSafe(PreviousRow, PreviousColumn, BoardOut),
            checkIfPieceIsSafe(PreviousRow, Column, BoardOut),
            checkIfPieceIsSafe(Row, PreviousColumn, BoardOut),
            checkIfPieceIsSafe(Row, NextColumn, BoardOut),
            checkIfPieceIsSafe(NextRow, PreviousColumn, BoardOut),
            checkIfPieceIsSafe(NextRow, Column, BoardOut)
        ) -> (ErrorType = 0 ; ErrorType = 2)
    ).

    

checkIfPieceIsSafe(Row, Column, Board):-
    %verifica se a peça está fora do bord
    (
        (Row > 0, Row < 12, 
        Column > 0, Column < 13) -> (
            %verifica se a peça é null
            checkIfNotNull2(Row, Column, Board, ErrorType),
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
                            checkAdjacentPiece(PreviousRow, PreviousColumn, Board, Color),
                            checkAdjacentPiece(PreviousRow, Column, Board, Color),
                            (
                                    PiecesEq == 2 -> true ; (
                                    checkAdjacentPiece(Row, PreviousColumn, Board, Color),
                                    ((PiecesEq == 2 ; PiecesDif == 3) -> true ; (
                                        checkAdjacentPiece(Row, NextColumn, Board, Color),
                                        ((PiecesEq == 2 ; PiecesDif == 3) -> true ; (
                                            checkAdjacentPiece(NextRow, PreviousColumn, Board, Color),
                                            ((PiecesEq == 2 ; PiecesDif == 3) -> true ; (
                                                checkAdjacentPiece(NextRow, Column, Board, Color),
                                                ((PiecesEq == 2 ; PiecesDif == 3) -> true ; ( 
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

checkAdjacentPiece(Row, Column, Board, Color) :-
    %verifica se a peça está fora do bord
    (
        (Row > 0, Row < 12, 
        Column > 0, Column < 13) -> (
            returnColorPiece(Row, Column, Board, ColorAdj),
            (
                ColorAdj == nullCell -> true ; 
                (
                    ColorAdj == Color -> (addEq, addDif); addDif
                )
            )
        ) ; true
    ).

initCounters :-
    retract(counterEq(PiecesEq)),
    PiecesEq1 = 0,
    assert(counterEq(PiecesEq1)),

    retract(counterDif(PiecesDif)),
    PiecesDif1 = 0,
    assert(counterDif(PiecesDif1)).

addEq :-
    retract(counterEq(PiecesEq)),
    PiecesEq1 is PiecesEq + 1,
    assert(counterEq(PiecesEq1)).

addDif :-
    retract(counterDif(PiecesDif)),
    PiecesDif1 is PiecesDif + 1,
    assert(counterDif(PiecesDif1)).

checkIfNotNull2(Row, Column, Board, ErrorType) :-
    checkRow(Row, Column, Board, ErrorType).

checkIfNotNull(Row, Column, ErrorType) :-
    initialBoard(In),
    checkRow(Row, Column, In, ErrorType).

checkColumn(1, [H|T], ErrorType):-
    (
        H == nullCell ->
        ErrorType = 1; 
        ErrorType = 0
    ).

checkColumn(Column, [H|T] , ErrorType):-
    Column > 1,
    ColumnI is Column - 1, 
    checkColumn(ColumnI, T, ErrorType).

checkRow(1, Column, [H|T], ErrorType):-
    checkColumn(Column, H, ErrorType).
    
checkRow(Row, Column, [H|T] , ErrorType):-
    Row > 1,
    RowNext is Row - 1, 
    checkRow(RowNext, Column, T, ErrorType).