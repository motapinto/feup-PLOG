%   include library's
:- [board].
:- [rules].
:- [players].
:- [shared].

%   To convert the letter the user inputs for the colum to a number
columnLetterToNumber('a', 1).
columnLetterToNumber('b', 2).
columnLetterToNumber('c', 3).
columnLetterToNumber('d', 4).
columnLetterToNumber('e', 5).
columnLetterToNumber('f', 6).
columnLetterToNumber('g', 7).
columnLetterToNumber('h', 8).
columnLetterToNumber('i', 9).
columnLetterToNumber('j', 10).
columnLetterToNumber('l', 11).
columnLetterToNumber('m', 12).

start(Mode):-
    use_module(library(random)),
    initialBoard(Init),
    player1(InitStash1),
    player2(InitStash2),
    printBoard, 
    playLoop(Mode),
    initGame(Init, InitStash1, InitStash2).

playLoop(Mode):-
    repeat, 
    if_then_else(
        Mode == 1,
        (
            write('player'),
            once(playRound(1)),
            write('player'),
            once(playRound(2))
        ),
        if_then_else(
            Mode == 2,
            (
                write('player'),
                once(playRound(1)),
                write('machine'),
                once(playRoundMachine(2))
            ),
            if_then_else(
                Mode == 3,
                (
                    once(playRoundMachine(1)),
                    once(playRoundMachine(2))
                ),
                fail
            )
        )     
    ),
    once(printPlayersCurrentScore),
    if_then_else(
       once(checkIfPlayersHaveWon), 
        write('THE PLAYERS HAVE WON THE GAME'), 
        fail
    ).

playRoundMachine(Player) :-
    format('Player ~w:\n', [Player]),
    removePieceAskMachine(Color, Player), 
    addPieceToWhatPlayer(Player, Color).

removePieceAskMachine(Color, Player):-
    random(1,11, Row),
    random(1,12, Column),
    if_then_else(
            checkRules(Row, Column, Player, 1),
            (
                removePieceDo(Row, Column, Color), 
                write('> Removing piece...\n'),
                format('> Row: ~d\n', Row),
                format('> Row: ~d\n', Column),
                printBoard
            ),
            removePieceAskMachine(Color, Player)
    ).

%   Restart the game parameters so that a new game can be played
initGame(InitBoard, Player1Stash, Player2Stash):-
     %returning the board to its initial state , ready for another round
     retract(initialBoard(_)),
     assert(initialBoard(InitBoard)),
     %returning the player1 stash to its initial state , ready for another round
     retract(player1(_)),
     assert(player1(Player1Stash)),
     %returning the player2 stash  to its initial state , ready for another round
     retract(player2(_)),
     assert(player2(Player2Stash)).


%   Loop of playing
%I agree that there is no command you can use to change a variable once 
%it is bound. What you can do though, is force backtracking through the 
%assignment, then this variable can be set again. 

playLoop :-
    repeat, 
    once(playRound(1)),
    once(playRound(2)),
    once(printPlayersCurrentScore),
    if_then_else(
        once(checkIfPlayersHaveWon), 
        write('THE PLAYERS HAVE WON THE GAME'), 
        fail
    ).

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
        %columnLetterToNumber(ColumnAux, Column),
        if_then_else(
            checkRules(Row, Column, Player,0),
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


%   Return color from piece with Row and Column, uses removePiece
%   but doesn't return no board without that piece, doing this
%   so we don't have another predicate doing a similiar function  
returnColorPiece(Row, Column, Color) :-
    initialBoard(Board),
    removePiece(Board, _, Row, Column, Color).

%   Same Function has before, but reveives a certain board to search in
returnColorPiece(Row, Column, Board, Color) :-
    removePiece(Board, _, Row, Column, Color).

%   Removes the piece from BoardIn and updates in BoardOut
removePiece(BoardIn, BoardOut, Row, Column, Color) :-
    updateRow(Row, Column, BoardIn, BoardOut, Color).

%   iterates through the columns of the board, return the Color of the Piece that was removed
updateColumn(1, [H|T], [Hout|T], Color):-
    Hout = n,
    Color = H.
updateColumn(Column, [H|T], [H|Tout], Color):-
    Column > 1,
    ColumnI is Column - 1, 
    updateColumn(ColumnI, T, Tout, Color).

%   Iterate through the rows of the board 
updateRow(1, Column, [H|T], [Hout|T], Color):-
    updateColumn(Column, H, Hout, Color).    
updateRow(Row, Column, [H|T], [H|Tout], Color):-
    Row > 1,
    RowNext is Row - 1, 
    updateRow(RowNext, Column, T, Tout, Color).