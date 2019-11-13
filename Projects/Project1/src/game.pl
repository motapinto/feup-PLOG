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

%   Inicializes all the game parameters
start(Mode, Level1, Level2):-
    randomizeBoard,
    initialBoard(Init),
    player1(InitStash1),
    player2(InitStash2),
    printBoard, 
    %sleep(3),
    playLoop(Mode, Level1, Level2),
    initGame(Init, InitStash1, InitStash2),
    !, fail.

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
playLoop(Mode, Level1, Level2):-
    repeat, 
    once(valid_moves(1, ListOfMoves1)),
    once(value(Value1, ListOfMoves1)),

    if_then_else(
        Value1 == 0,
        write('\n Game Has Won , no more Possible Moves Available\n'),
        (
            if_then_else(
                (
                    Mode == 1; 
                    Mode == 2
                ),
                once(playRound(1)),
                once(playRoundMachine(1, Level1, ListOfMoves1))
            ),

            printBoard,
            %sleep(3),
            once(valid_moves(2, ListOfMoves2)),
            once(value(Value2, ListOfMoves2)),
            
            if_then_else(
                Value2 == 0,
                write('\n Game Has Won , no more Possible Moves Available\n'),
                (
                    if_then_else(
                        Mode == 1,
                        once(playRound(2)),
                        once(playRoundMachine(2, Level2, ListOfMoves2))
                    ),
                    
                    printBoard,
                    %sleep(3),
                    if_then_else(
                    once(checkIfPlayersHaveWon), 
                        write('\n The Players have won the game \n'), 
                        (!, fail)
                )
            )
        )
    )
    ).

%   Asks for user input and add's the removed piece to the player stash
playRound(Player) :-
    format('\nPlayer ~w:\n\n', [Player]),
    removePieceAsk(Player, Color), 
    addPieceToWhatPlayer(Player, Color).

%   Randomizes piece to remove and add's the removed piece to the player stash
playRoundMachine(Player, Difficulty, ListOfMoves) :-
    format('\nMachine ~w:\n\n', [Player]),
    removePieceAskMachine(Player, Difficulty, Color, ListOfMoves), 
    addPieceToWhatPlayer(Player, Color).

%   Asks for user input to decide piece to be removed and checks if it is a legal move
removePieceAsk(Player, Color) :-
    write('    > Select row: '),
    read(Row), 
    write('    > Select column: '),
    read(Column),
    if_then_else(
        checkRules(Row, Column, Player, 0),
        removePieceDo(Row, Column, Color), 
        removePieceAsk(Player, Color)
    ).

%   Randomizes piece to remove and checks if it is a legal move for AI level 0
removePieceAskMachine(Player, Difficulty, Color, _):-
    Difficulty == 0, !,
    randomMove(Row, Column),
    if_then_else(
            checkRules(Row, Column, Player, 1),
            (
                removePieceDo(Row, Column, Color),

                format('    > Row: ~d\n', Row),
                format('    > Column: ~d\n', Column)
            ),
            removePieceAskMachine(Player, Difficulty, Color, _)
    ).

%   Chooses first play of possible moves for AI level 1
removePieceAskMachine(_, Difficulty, Color, ListOfMoves):-
    Difficulty == 1, !,
    choosePieceToRemove(Row, Column, ListOfMoves), 
    removePieceDo(Row, Column, Color), 
    write('    > Removing piece...\n'),
    format('    > Row: ~d\n', Row),
    format('    > Column: ~d\n', Column).

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
removePiece(In, Out, Row, Column, Color) :-
    RowIndex is Row - 1,
    ColumnIndex is Column - 1,
    returnColorPiece(Row, Column, In, Color),
    %   Get's the Row in RowIndex of the Board
    nth0(RowIndex, In, RowElem),
    changeElemInList(ColumnIndex, RowElem, n, NewRowElem),
    changeElemInList(RowIndex, In, NewRowElem, Out).

%   Returns the number of valid moves
value(Value, ListOfMoves):-
    length(ListOfMoves, Value).

value2(ListOfMoves, Player, Row, Column):-
    initialBoard(Board),
    
    iterateListOfMoves(ListOfMoves, Board, Player),
    write(ListOfMoves).


iterateListOfMoves([], _, _).
iterateListOfMoves([H|T], Board, Player):-
    nth0(0, H, RowA),
    nth0(1, H, ColumnA),
    removePiece(Board, BoardOut, RowA, ColumnA, _),
    valid_moves(Player, ListOfMoves, BoardOut),
    value(NewNumberOfPossibleMoves, ListOfMoves),

    iterateListOfMoves(T, Board, Player).


%   Returns the list of valid moves of a certain board
valid_moves(Player, ListOfMoves, Board) :-
    findall([Row,Column], iterateBoard(Board, Row, Column, Player), ListOfMoves),
    write('Possibe Moves: '), write(ListOfMoves).


%   Returns the list of valid moves
valid_moves(Player, ListOfMoves) :-
    initialBoard(Board),
    findall([Row,Column], iterateBoard(Board, Row, Column, Player), ListOfMoves),
    write('Possibe Moves: '), write(ListOfMoves).

%   COMMENT
iterateBoard(Board, Row, Column, Player):-
    iterateRows(Board, Row, Column, 1, 1, Player).

%   COMMENT
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

%   COMMENT
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