%   include library's
:- [board].
:- [rules].
:- [players].
:- [machine].

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
    randomizeBoard,
    initialBoard(Init),
    player1(InitStash1),
    player2(InitStash2),
    printBoard, 
    %sleep(3),
    playLoop(Mode, Difficulty),
    initGame(Init, InitStash1, InitStash2),
    !,
    fail.

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
    once(valid_moves(1, ListOfMoves1)),
    once(value(Value1, ListOfMoves1)),

    if_then_else(
        Value1 == 0,
        write('\n Game Has Won , no more Possible Moves Available\n'),
        (
            if_then_else(
                (
                    Mode==1; 
                    Mode== 2
                ),
                once(playRound(1)),
                once(playRoundMachine(1, Difficulty, Value1, ListOfMoves1))
            ),

            printBoard,
            once(valid_moves(2, ListOfMoves2)),
            once(value(Value2, ListOfMoves2)),
            
            if_then_else(
                Value2 == 0,
                write('\n Game Has Won , no more Possible Moves Available\n'),
                (
                    if_then_else(
                        Mode == 1,
                        once(playRound(2)),
                        once(playRoundMachine(2, Difficulty, Value2, ListOfMoves2))
                    ),
                    
                    printBoard,

                    if_then_else(
                    once(checkIfPlayersHaveWon), 
                        write('\n The Players have won the game \n'), 
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
playRoundMachine(Player, Difficulty, CounterRet, ListOfMoves) :-
    format('\nMachine ~w:\n\n', [Player]),
    removePieceAskMachine(Color, Player, Difficulty, CounterRet, ListOfMoves), 
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
removePieceAskMachine(Color, Player, Difficulty, CounterRet, _):-        
    Difficulty == 0, !,
    randomMove(Row, Column),
    if_then_else(
            checkRules(Row, Column, Player, 1),
            (
                removePieceDo(Row, Column, Color),

                format('    > Row: ~d\n', Row),
                format('    > Column: ~d\n', Column)
            ),
            removePieceAskMachine(Color, Player, Difficulty, CounterRet, _)
    ).

%   Chooses first play of possible moves for AI level 1
removePieceAskMachine(Color, Player, Difficulty, CounterRet, ListOfMoves):-
    Difficulty == 1, !,
    write('asdasda\n\n1111\n'),
    choosePieceToRemove(Row, Column, CounterRet, ListOfMoves),
    if_then_else(
            (write('Consegui'),
            checkRules(Row, Column, Player, 1),
            write('Consegui1')
            ),
            (   
                removePieceDo(Row, Column, Color), 
                write('    > Removing piece...\n'),
                format('    > Row: ~d\n', Row),
                format('    > Column: ~d\n', Column)
            ),
            removePieceAskMachine(Color, Player, Difficulty, CounterRet)
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
    RowIndex is Row - 1,
    ColumnIndex is Column - 1,
    nth0(RowIndex, Board, Element),
    nth0(ColumnIndex, Element, Element2),
    Color = Element2.

%   Same Function has before, but reveives a certain board to search in
returnColorPiece(Row, Column, Board, Color) :-
    RowIndex is Row - 1,
    ColumnIndex is Column - 1,
    nth0(RowIndex, Board, Element),
    nth0(ColumnIndex, Element, Element2),
    Color = Element2.

%   Removes the piece from BoardIn and updates in BoardOut
removePiece(BoardIn, BoardOut, Row, Column) :-
    updateRow(Row, Column, BoardIn, BoardOut).

%   Iterates through the columns of the board, return the Color of the Piece that was removed
updateColumn(1, [H|T], [Hout|T]):-
    Hout = n.

updateColumn(Column, [H|T], [H|Tout]):-
    Column > 1,
    ColumnI is Column - 1, 
    updateColumn(ColumnI, T, Tout).

%   Iterate through the rows of the board 
updateRow(1, Column, [H|T], [Hout|T]):-
    updateColumn(Column, H, Hout).    
updateRow(Row, Column, [H|T], [H|Tout]):-
    Row > 1,
    RowNext is Row - 1, 
    updateRow(RowNext, Column, T, Tout).


%   Returns the number of valid moves
value(Value, ListOfMoves):-
    length(ListOfMoves, Value).

%   Returns the list of valid moves
validmoves(Player, ListOfMoves) :-
    initialBoard(Board),
    findall([Row,Column], iterateBoard(Board, Row, Column, Player), ListOfMoves),
    write(ListOfMoves).

iterateBoard(Board, Row, Column, Player):-
    iterateRows(Board, Row, Column, 1, 1, Player).

iterateRows([], _, _, _, _, _):- fail.
iterateRows([H|T], Row, Column, Row1, Column1, Player):-
    (
        iterateRow(H, Row1, Column, Column1, Player),
        Row is Row1
    );
    (
        Row2 is Row1 + 1,
        iterateRows(T, Row, Column, Row2, 1, Player)
    ).

iterateRow([], _, _, _, _) :- fail.
iterateRow([H|T], Row1, Column, Column1, Player):-
    (
        checkRules(Row1, Column1, Player, 1),
        Column is Column1
    );
    (
        Column2 is Column1 + 1,
        iterateRow(T, Row1, Column, Column2, Player)

    ).