:- (dynamic counterEq/1).
:- (dynamic counterDif/1).

%   Number of  adjacent pieces with the same color for the specific piece
counterEq(0).
%   Number of all adjacent pieces for the specific pieces
counterDif(0).

%   Checks all in game rules and if the piece in the position with Row and Column can be removed
checkRules(Row, Column, Player, IsMachine):-
    %   Detecting if the input values of the player are valid
    if_then_else(
        checkRowAndColumn(Row, Column),
        true,
        (
            if_then_else(
                IsMachine == 0,
                (
                    write('Tried to remove a piece that is out of bonds\n'),
                    (!, fail)   
                ),
                (!, fail)  
            )
        )
    ), !,

    %   Determining if the piece in position chosen by the player is empty
    returnColorPiece(Row, Column, Color), !,
    if_then_else(
            Color \== n,
            true,
            (
                if_then_else(
                        IsMachine == 0,
                        (
                            write('Tried to remove a piece that doesnt exist\n'),
                            (!, fail)     
                        ),
                        (!, fail)  
                )
            )
    ),
    
    %   Checking if the player already has the max amount of pieces for
    %   a certain Color
    if_then_else(
        checkPieceLimit(Color, Player),
        true,
        (
            if_then_else(
                IsMachine == 0,
                (
                    write('Tried to remove a piece that has reached its type limit for the player\n'),
                    (!, fail)  
                ),
                (!, fail)  
            )

        )
    ),
    % Checks if the piece is connected to six others
    if_then_else(
        checkIfBreaksTree(Row, Column),
        (!, fail),
        true
    ),

    %   Checking if removing the piece the player has choosen, makes other pieces
    %   around it unsafe
    if_then_else(
            checkIfPiecesAreSafe(Row, Column),
            true,
            (
                if_then_else(
                        IsMachine == 0,
                        (
                            write('\n    > Tried to remove a piece that makes other pieces unprotected!\n\n'), 
                            (!, fail)  
                        ),
                        (!, fail)  
                )
            )
    ).

%   Checks if the Row and Column are inside the board of play
checkRowAndColumn(Row, Column):-
    Row > 0, 
    Row < 12, 
    Column > 0, 
    Column < 13.

%   Checks if all 6 adjacent pieces are safe after simulation removing the piece
checkIfPiecesAreSafe(Row, Column):- 
    retract(initialBoard(BoardIn)),
    removePiece(BoardIn, BoardOut, Row, Column, _),
    assert(initialBoard(BoardIn)),

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
    
%   Checks if each of the 6 adjacent pieces are safe (connected to 3 or 2 of the same color)
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
                                                        (!, fail)  
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

% Updates number of pieces connected to the calle of this predicate
checkAdjacentPiece(Row, Column, Board, Color) :-
    %Cehcks if the piece is inside the board
    if_then_else(
        checkRowAndColumn(Row,Column),
        (
            returnColorPiece(Row, Column, Board, ColorAdj), !,
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

%   Checks if the breaks tree (if there is 1 path that connect all pieces)
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

%   Checks if adjacent piece is null
checkIfAdjacentPositionIsPiece(Row, Column) :-
    if_then_else(
        checkRowAndColumn(Row,Column),
        (
            returnColorPiece(Row, Column, Color), !,
            if_then_else(
                Color == n,
                (!, fail),  
                true  
            )  
        ),
        (!, fail)  
    ).


%   Inicializes the counter for counterEq and counterDif
initCounters :-
    retract(counterEq(_)),
    PiecesEq1 = 0,
    assert(counterEq(PiecesEq1)),

    retract(counterDif(_)),
    PiecesDif1 = 0,
    assert(counterDif(PiecesDif1)).

%   Increments the number of equal adjacent pieces
addEq :-
    retract(counterEq(PiecesEq)),
    PiecesEq1 is PiecesEq + 1,
    assert(counterEq(PiecesEq1)).

%   Increments the number of all adjacent pieces
addDif :-
    retract(counterDif(PiecesDif)),
    PiecesDif1 is PiecesDif + 1,
    assert(counterDif(PiecesDif1)).