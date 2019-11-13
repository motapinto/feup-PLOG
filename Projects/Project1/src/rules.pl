:- (dynamic counterEq/1).
:- (dynamic counterDif/1).

%   Counter for the number of Pieces with the same color and Pieces in
%   in general
counterEq(0).
counterDif(0).


checkRules(Row, Column, Player, IsMachine):-
    %   Detecting if the values in the input of the player are valid

    write('Row: '),
    write(Row),
    write(' Column: '),
    write(Column),
    write('                  '),



    if_then_else(
        (write(' 1 -'),
        checkRowAndColumn(Row, Column)),
        true,
        (
            if_then_else(
                IsMachine == 0,
                (
                    write('Tried to remove a piece that is out of bonds\n'),
                    nl, fail  
                ),
               (nl, fail)  
            )
        )
    ), !,

    %   Determining id the spot chosen by the player is a null one or
    %   if it correspond to an actual piece
    returnColorPiece(Row, Column, Color),

    if_then_else(
            (write(' 2 -'),Color \== n),
            true,
            (
                if_then_else(
                        IsMachine == 0,
                        (
                            write('Tried to remove a piece that doesnt exist\n'), 
                            !,
                            nl, fail    
                        ),
                        (nl, fail  )
                )
            )
    ), !,
    
    %   Checking if the player already has the max amount of pieces with
    %   a certain Color
    if_then_else(
        (write(' 3 -'),checkPieceLimit(Color, Player)),
        true,
        (
            if_then_else(
                IsMachine == 0,
                (
                    write('Tried to remove a piece that has reached its type limit for the player\n'),
                    !,
                    nl, fail  
                ),
                (nl, fail  )
            )

        )
    ), !,
    % Checks if the piece is connected to six others
    if_then_else(
        (write(' 4 -'),checkIfBreaksTree(Row, Column)),
        (nl, fail),  
        true
    ), !,

    %   Checking if removing the piece the player choose makes other pieces
    %   around it unsafe
    if_then_else(
            (write(' 5 -'),checkIfPiecesAreSafe(Row, Column)),
            true,
            (
                if_then_else(
                        IsMachine == 0,
                        (
                            write('\n    > Tried to remove a piece that makes other pieces unprotected!\n\n'), 
                            !,
                         nl, fail  
                        ),
                    (  nl, fail  )
                )
            )
    ), !,

write(' 6 -'),
    nl.

checkRowAndColumn(Row, Column):-
    Row > 0, 
    Row < 12, 
    Column > 0, 
    Column < 13.



checkIfPiecesAreSafe(Row, Column):-
    
    retract(initialBoard(BoardIn)),
    removePiece(BoardIn, BoardOut, Row, Column, _),
    assert(initialBoard(BoardIn)),

  %  printBoard(BoardOut).

    PreviousRow is Row - 1,
    NextRow is Row + 1,
    PreviousColumn is Column - 1,
    NextColumn is Column + 1,
    (
        if_then_else(
            (   Aux is Row mod 2,
                Aux == 0
            ),
            (
                checkIfPieceIsSafe(PreviousRow, Column, BoardOut),!,
                checkIfPieceIsSafe(PreviousRow, NextColumn, BoardOut),!
            ),
            (
                checkIfPieceIsSafe(PreviousRow, PreviousColumn, BoardOut),!,
                checkIfPieceIsSafe(PreviousRow, Column, BoardOut),!
            )
        ),
        checkIfPieceIsSafe(Row, PreviousColumn, BoardOut),!,
        checkIfPieceIsSafe(Row, NextColumn, BoardOut),!,
        if_then_else(
                (   Aux is Row mod 2,
                    Aux == 0
                ),
                (
                    checkIfPieceIsSafe(NextRow, Column, BoardOut),!,
                    checkIfPieceIsSafe(NextRow, NextColumn, BoardOut),!
                ),
                (
                    checkIfPieceIsSafe(NextRow, PreviousColumn, BoardOut),!,
                    checkIfPieceIsSafe(NextRow, Column, BoardOut),!
                )
            )
    ).

    

checkIfPieceIsSafe(Row, Column, Board):-
   
    %   Index for the surrounding pieces
    if_then_else(
        checkRowAndColumn(Row,Column),
        (
            returnColorPiece(Row, Column,Board, Color),
            if_then_else(
                Color == n, 
                true,
                (  
                    PreviousRow is Row - 1,
                    NextRow is Row + 1,
                    PreviousColumn is Column - 1,
                    NextColumn is Column + 1,
        
                    % Restart the counter back to 0 after a call to the predicate
                    initCounters,
                    if_then_else(
                        (   Aux is Row mod 2,
                            Aux == 0
                        ),
                        (
                            checkAdjacentPiece(PreviousRow, Column, Board, Color),
                            checkAdjacentPiece(PreviousRow, NextColumn, Board, Color)
                        ),
                        (
                            checkAdjacentPiece(PreviousRow, PreviousColumn, Board, Color),
                            checkAdjacentPiece(PreviousRow, Column, Board, Color)
                        )
                    ),
                    counterEq(PiecesEq),
                    if_then_else(
                        PiecesEq == 2,
                        true,
                        (   
                            checkAdjacentPiece(Row, PreviousColumn, Board, Color),
                            counterEq(PiecesEq1),counterDif(PiecesDif),
                            if_then_else(
                                (
                                    PiecesEq1 == 2;
                                    PiecesDif == 3
                                ),
                                true,
                                (
                                    
                                    checkAdjacentPiece(Row, NextColumn, Board, Color),
                                    counterEq(PiecesEq2),counterDif(PiecesDif1),
        
                                    if_then_else(
                                        (
                                            PiecesEq2 == 2;
                                            PiecesDif1 == 3
                                        ),
                                        true,
                                        (
                                            
                                            if_then_else(
                                                (
                                                    Aux is Row mod 2,
                                                    Aux == 0
                                                ),
                                                checkAdjacentPiece(NextRow, Column, Board, Color),
                                                checkAdjacentPiece(NextRow, PreviousColumn, Board, Color)
                                            ),
                                            counterEq(PiecesEq3),counterDif(PiecesDif2),
                
                                            if_then_else(
                                                (
                                                    PiecesEq3 == 2;
                                                    PiecesDif2 == 3
                                                ),
                                                true,
                                                (
                                                    
                                                    if_then_else(
                                                            (
                                                                Aux is Row mod 2,
                                                                Aux == 0
                                                            ),
                                                            checkAdjacentPiece(NextRow, NextColumn, Board, Color),
                                                            checkAdjacentPiece(NextRow, Column, Board, Color)
                                                    ),
                                                    counterEq(PiecesEq4),counterDif(PiecesDif3),
                                                    !,
                                                    if_then_else(
                                                        (
                                                            PiecesEq4 == 2;
                                                            PiecesDif3 == 3
                                                        ),
                                                        true,
                                                        fail
                                                    ) 
                                                    
                                                )
                                            )   
                                        )
                                    )
                                )
                            )
                        )
                    ) 
                )       
            )
        ),
        true
    ).                   

checkAdjacentPiece(Row, Column, Board, Color) :-
    %verifica se a peça está fora do bord
    if_then_else(
        checkRowAndColumn(Row,Column),
        (
            returnColorPiece(Row, Column, Board, ColorAdj),
            if_then_else(
                ColorAdj == n,
                true,
                (
                    if_then_else(
                        ColorAdj == Color,
                        (
                            addEq,
                            addDif
                        ),
                        addDif
                    )
                )
            )
        ),
        true
    ).

checkIfBreaksTree(Row, Column) :-
    PreviousRow is Row - 1,
    NextRow is Row + 1,
    PreviousColumn is Column - 1,
    NextColumn is Column + 1,
    
    if_then_else(
        (   Aux is Row mod 2,
            Aux == 0
        ),
        (
             checkIfAdjacentPositionIsPiece(PreviousRow, Column),!,
             checkIfAdjacentPositionIsPiece(PreviousRow, NextColumn),!
        ),
        (
             checkIfAdjacentPositionIsPiece(PreviousRow, PreviousColumn),!,
             checkIfAdjacentPositionIsPiece(PreviousRow, Column),!
        )
    ),

     checkIfAdjacentPositionIsPiece(Row, PreviousColumn),!,
     checkIfAdjacentPositionIsPiece(Row, NextColumn),!,

    if_then_else(
        (   Aux is Row mod 2,
            Aux == 0
        ),
        (
                 checkIfAdjacentPositionIsPiece(NextRow, Column),!,
                 checkIfAdjacentPositionIsPiece(NextRow, NextColumn),!
        ),
        (
                 checkIfAdjacentPositionIsPiece(NextRow, PreviousColumn),!,
                 checkIfAdjacentPositionIsPiece(NextRow, Column),!
        )
    ).

checkIfAdjacentPositionIsPiece(Row, Column) :-
    if_then_else(
        checkRowAndColumn(Row,Column),
        (
            returnColorPiece(Row, Column, Color), !,
            if_then_else(
                Color == n,
                fail,
                true  
            )  
        ),
        fail
    ).



initCounters :-
    retract(counterEq(_)),
    PiecesEq1 = 0,
    assert(counterEq(PiecesEq1)),

    retract(counterDif(_)),
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
