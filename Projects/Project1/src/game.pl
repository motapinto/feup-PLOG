%   include library's
:- [board].
:- [rules].

%   Starts players with player mode
startPP :-
    initGame(Init),
    playLoop.

%   Randomizes initial Board and prints it
initGame(BoardIn) :-
    initialBoard(BoardIn),
    printBoard(BoardIn).

%   Loop of playing
%I agree that there is no command you can use to change a variable once 
%it is bound. What you can do though, is force backtracking through the 
%assignment, then this variable can be set again. 

playLoop:-
    
    write('Player1:\n'),
    initialBoard(BoardIn),
    removePieceAsk(Row, Column),
    removePieceDo(BoardIn, BoardOut, Row, Column),
    printBoard(BoardOut),

    write('Player2:\n'),
    removePieceAsk(Row1, Column1),
    removePieceDo(BoardOut, BoardOut2, Row1, Column1),
    printBoard(BoardOut2),
    playLoop.

%   Asks for user input to decide specifics of
%   the play move, specifically row and column
removePieceAsk(Row, Column) :-
        write('> Removing piece...\n'),
        write('> Select row: '),
        read(Row), 
        write('> Select column: '),
        read(Column),
        checkMove(Row, Column , ErrorType),
        (
                ErrorType == 0 -> true ;         
                (
                    removePieceAsk(Row1, Column1)
                )
        ).

removePieceDo(BoardIn, BoardOut, Row, Column) :-
    retract(initialBoard(BoardIn)),
    removePiece(BoardIn, BoardOut, Row, Column),
    assert(initialBoard(BoardOut)).

%   Checks if row, column respect board limits

checkMove(Row, Column, ErrorType):-
        (
            Row > 0, 
            Row < 12, 
            Column > 0, 
            Column < 13 , 
            checkRules(Row, Column, ErrorType),
            (
                ErrorType == 0 -> true ;         
                (
                    (
                        (ErrorType == 1, write('Tried to remove a piece that doesnt exist\n'));
                        (ErrorType == 2,  write('Tried to remove a piece that makes other pieces unprotected\n'));
                        (ErrorType == 3,  write('Tried to remove a piece that breaks the game tree\n'))
                    ),
                    write(' Try Again \n')
                )
            )
        ).

%   Removes the piece from BoardIn and updates in BoardOut
removePiece(BoardIn, BoardOut, Row, Column) :-
    updateRow(Row, Column, BoardIn, BoardOut).

%
updateColumn(1, [H|T], [Hout|T]):-
    Hout = nullCell.
%
updateColumn(Column, [H|T], [H|Tout]):-
    Column > 1,
    ColumnI is Column - 1, 
    updateColumn(ColumnI, T, Tout).
%
updateRow(1, Column, [H|T], [Hout|T]):-
    updateColumn(Column, H, Hout).
%    
updateRow(Row, Column, [H|T], [H|Tout]):-
    Row > 1,
    RowNext is Row - 1, 
    updateRow(RowNext, Column, T, Tout).