%   include library's
:- [board].
:- [rules].
:- [players].
:- [machine].
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

%   Inicializes the all game parameters
start(Mode, Difficulty):-
    use_module(library(random)),
    use_module(library(system)),
    randomizeBoard,
    initialBoard(Init),
    player1(InitStash1),
    player2(InitStash2),
    printBoard, 
    %sleep(3),
    playLoop(Mode, Difficulty),
    initGame(Init, InitStash1, InitStash2).

%   Restart the game parameters so that a new game can be played
initGame(InitBoard, Player1Stash, Player2Stash):-
    %   returning the board to its initial state , ready for another round
    retract(initialBoard(_)),
    assert(initialBoard(InitBoard)),
    %   returning the player1 stash to its initial state , ready for another round
    retract(player1(_)),
    assert(player1(Player1Stash)),
    %   returning the player2 stash  to its initial state , ready for another round
    retract(player2(_)),
    assert(player2(Player2Stash)).

%   Loop of play of all 3 modes
playLoop(Mode, Difficulty):-
    repeat, 
    
    once(computePossibleMoves(1, CounterRet)),

    if_then_else(
        CounterRet == 0,
        write('Game Has Won , no more Possible Moves Available\n'),
        (
            if_then_else(
                (
                    Mode==1; 
                    Mode== 2
                ),
                once(playRound(1)),
                once(playRoundMachine(1, Difficulty, CounterRet))
            ),

            printBoard,
            once(computePossibleMoves(2, CounterRet1)),
            
            if_then_else(
                CounterRet1 == 0,
                write('Game Has Won , no more Possible Moves Available\n'),
                (
                    if_then_else(
                        Mode == 1,
                        once(playRound(2)),
                        once(playRoundMachine(2, Difficulty, CounterRet1))
                    ),
                    printBoard,

                    once(printPlayersScore),
                    if_then_else(
                    once(checkIfPlayersHaveWon), 
                        write('THE PLAYERS HAVE WON THE GAME'), 
                        fail
                )
            )
        )
    )
).
    

%   Asks for user input and add's the removed piece to the player stash
playRound(Player) :-
    format('\nPlayer ~w:\n\n', [Player]),
    removePieceAsk(Color, Player), 
    addPieceToWhatPlayer(Player, Color).

%   Randomizes piece to remove and add's the removed piece to the player stash
playRoundMachine(Player, Difficulty, CounterRet) :-
    removePieceAskMachine(Color, Player, Difficulty, CounterRet), 
    addPieceToWhatPlayer(Player, Color).

%   Asks for user input to decide piece to be removed and checks if it is a legal move
removePieceAsk(Color, Player) :-
    write('    > Select row: '),
    read(Row), 
    write('    > Select column: '),
    read(Column),
    %columnLetterToNumber(ColumnAux, Column),
    if_then_else(
        checkRules(Row, Column, Player, 0),
        removePieceDo(Row, Column, Color), 
        removePieceAsk(Color, Player)
    ).

%   Randomizes piece to remove and checks if it is a legal move for AI level 0
removePieceAskMachine(Color, Player, Difficulty, CounterRet):-
    if_then_else(
        Difficulty == 0,
        (   random(1,11, Row),
            random(1,12, Column)
        ),
        (
        %sleep(2),
        choosePieceToRemove(Row, Column, CounterRet))
    ),
    if_then_else(
            checkRules(Row, Column, Player, 1),
            (
                removePieceDo(Row, Column, Color), 
                format('    > Row: ~d\n', Row),
                format('    > Row: ~d\n', Column)
            ),
            removePieceAskMachine(Color, Player, Difficulty, CounterRet)
    ).

%   Chooses first play of possible moves for AI level 1
removePieceAskMachine(Color, Player, Difficulty):-
    Difficulty == 1, !,
    random(1,11, Row),
    random(1,12, Column),
    if_then_else(
            checkRules(Row, Column, Player, 1),
            (
                removePieceDo(Row, Column, Color), 
                write('    > Removing piece...\n'),
                format('    > Row: ~d\n', Row),
                format('    > Column: ~d\n', Column)
            ),
            removePieceAskMachine(Color, Player, Difficulty)
    ).

%   After checking if the move is legal, removes piece
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

%   Iterates through the columns of the board, return the Color of the Piece that was removed
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
