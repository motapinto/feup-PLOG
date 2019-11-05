%   include library's
:- [board].
:- [rules].
:- [players].
:- [shared].

%   Starts players with player mode
startPP :-
    %   Saving Initial configuration
    initialBoard(Init),
    player1(InitStash1),
    player2(InitStash2),

    printBoard, 
    playLoop,
    initGame.
    
%   Restart the game parameters so that a new game can be played
initGame(InitBoard, Player1Stash, Player2Stash):-
     %returning the board to its initial state , ready for another round
     retract(initialBoard(_)),
     assert(initialBoard(Init)),
     %returning the player1 stash to its initial state , ready for another round
     retract(player1(_)),
     assert(player1(InitStash1)),
     %returning the player2 stash  to its initial state , ready for another round
     retract(player2(_)),
     assert(player2(InitStash2)).


%   Loop of playing
%I agree that there is no command you can use to change a variable once 
%it is bound. What you can do though, is force backtracking through the 
%assignment, then this variable can be set again. 

playLoop :-
    initGame,
    repeat, 
    once(playRound(1)),
    once(playRound(2)),
    once(printPlayersCurrentScore),
    if_then_else(once(checkIfPlayersHaveWon), true, fail).

playRound(Player) :-
    format('Player ~w:\n', [Player]),
    removePieceAsk(Color, Player), 
    addPieceToWhatPlayer(Player, Color).


%   Asks for user input to decide specifics of
%   the play move, specifically row and column
removePieceAsk(Color, Player) :-
        write('> Removing piece...\n'),
        write('> Select row: '),
        read(Row), 
        write('> Select column: '),
        read(Column),
        if_then_else(
            checkMove(Row, Column, Player),
            (
                removePieceDo(Row, Column, Color), 
                printBoard
            ),
            removePieceAsk(Color, Player)
        ).

removePieceDo(Row, Column, Color):-
    retract(initialBoard(BoardIn)),
    removePiece(BoardIn, BoardOut, Row, Column, Color),
    assert(initialBoard(BoardOut)).

%   Checks if row, column respect board limits

checkMove(Row, Column, Player):-
    
    if_then_else(
        (
            Row > 0, 
            Row < 12, 
            Column > 0, 
            Column < 13
        ), 
        (
            returnColorPiece(Row, Column, Color),
            if_then_else(
                Color \== n,
                if_then_else(
                    checkPieceLimit(Color, Player),
                    (
                        checkRules(Row, Column, ErrorType),
                        if_then_else(
                            ErrorType == 0, 
                            true,
                            if_then_else(
                                ErrorType == 1,
                                (    
                                    write('Tried to remove a piece that doesnt exist\n'), 
                                    fail
                                ),
                                if_then_else(
                                        ErrorType == 2,
                                        (    
                                            write('Tried to remove a piece that makes other pieces unprotected\n'), 
                                            fail
                                        ),
                                        if_then_else(
                                                ErrorType == 3,
                                                (    
                                                    write('Tried to remove a piece that breaks the game tree\n'), 
                                                    fail
                                                ), true

                            write('Tried to remove a piece that has reached its type limit for the player\n'),
                        fail
                    )
                ),
                fail
            )
        ),
        (
            write('Tried to remove a piece that is out of bonds\n'),
            fail
        ).
    (
        (
            ErrorType == 0 -> true ;         
            (
                (
                    (ErrorType == 1, write('Tried to remove a piece that doesnt exist\n'));
                    (ErrorType == 2,  write('Tried to remove a piece that makes other pieces unprotected\n'));
                    (ErrorType == 3,  write('Tried to remove a piece that breaks the game tree\n'));
                    (ErrorType == 4,  write('Tried to remove a piece that is out of bonds\n'));
                    (ErrorType == 5,  write('Tried to remove a piece that has reached its type limit for the player\n'))
                ),
                write(' Try Again \n')
            )
        )
    ).


%   Return color from piece with Row and Column
returnColorPiece(Row, Column, Board, Color) :-
    removePiece(Board, _, Row, Column, Color).

%   Removes the piece from BoardIn and updates in BoardOut
removePiece(BoardIn, BoardOut, Row, Column, Color) :-
    updateRow(Row, Column, BoardIn, BoardOut, Color).

%
updateColumn(1, [H|T], [Hout|T], Color):-
    Hout = n,
    Color = H.
%
updateColumn(Column, [H|T], [H|Tout], Color):-
    Column > 1,
    ColumnI is Column - 1, 
    updateColumn(ColumnI, T, Tout, Color).
%
updateRow(1, Column, [H|T], [Hout|T], Color):-
    updateColumn(Column, H, Hout, Color).
%    
updateRow(Row, Column, [H|T], [H|Tout], Color):-
    Row > 1,
    RowNext is Row - 1, 
    updateRow(RowNext, Column, T, Tout, Color).