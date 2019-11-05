%   include library's
:- [board].
:- [rules].
:- [players].

%   Starts players with player mode
startPP :-
    initialBoard(Init),
    player1(InitStash1),
    player2(InitStash2),
    playLoop,
    %returning the board to its initial state , ready for another round
    retract(initialBoard(_)),
    assert(initialBoard(Init)),
    %returning the player1 stash to its initial state , ready for another round
    retract(player1(_)),
    assert(player1(InitStash1)),
    %returning the player2 stash  to its initial state , ready for another round
    retract(player2(_)),
    assert(player2(InitStash2)).
    

playLoop :-
    initGame,
    repeat, 
    once(playRound(1)),
    once(checkIfPlayersHaveWon(Exit1)),
    once(playRound(2)),
    once(checkIfPlayersHaveWon(Exit2)),
    once(printPlayersCurrentScore),
    ((Exit1 == 0, Exit2 == 0) -> fail; true).

%   Randomizes initial Board and prints it
initGame:-
    initialBoard(BoardIn),
    printBoard(BoardIn).

%   Loop of playing
%I agree that there is no command you can use to change a variable once 
%it is bound. What you can do though, is force backtracking through the 
%assignment, then this variable can be set again. 

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
        checkMove(Row, Column , ErrorType, Player),
        initialBoard(BoardIn),
        (
                ErrorType == 0 -> (
                                    removePieceDo(BoardIn, BoardOut, Row, Column, Color), 
                                    printBoard(BoardOut)
                                  );         
                (
                    removePieceAsk(Color, Player)
                )
        ).

removePieceDo(BoardIn, BoardOut, Row, Column, Color) :-
    retract(initialBoard(BoardIn)),
    removePiece(BoardIn, BoardOut, Row, Column, Color),
    assert(initialBoard(BoardOut)).

%   Checks if row, column respect board limits

checkMove(Row, Column, ErrorType, Player):-

    checkPlayerPieceColorStash(Row, Column, ErrorType, Player),
    write('sai'),
    (
        ErrorType == 5 -> true ;   
        (
            (Row > 0, Row < 12, Column > 0, Column < 13) -> checkRules(Row, Column, ErrorType);
            ErrorType = 4
        )
    ),
    
    format('ERROR TYPE move ~w\n', ErrorType),
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