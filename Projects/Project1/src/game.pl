%   include library's
:- [board].
:- [rules].
:- [players].

%   Starts players with player mode
startPP :-
    initGame(Init), !, 
    playLoop.

%   Randomizes initial Board and prints it
initGame(BoardIn) :-
    initialBoard(BoardIn),
    %randomBoard(BoardIn),
    printBoard(BoardIn).

%   Loop of playing
%I agree that there is no command you can use to change a variable once 
%it is bound. What you can do though, is force backtracking through the 
%assignment, then this variable can be set again. 

<<<<<<< Updated upstream
playLoop :-
    
    write('Player1:\n'),
    removePieceAsk(Color, 1), 
    addPieceToWhatPlayer(1, Color), !,
    checkIfPlayersHaveWon(Exit), 
    (Exit == 1 -> false; true),
    
    write('Player2:\n'),
    removePieceAsk(Color2, 2), 
    addPieceToWhatPlayer(2, Color2), !,
    checkIfPlayersHaveWon(Exit1),
    (Exit1 == 1 -> false; true),
    
    printPlayersCurrentScore,
    
    playLoop.

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
=======
%   Loop of play of all 3 modes
playLoop(Mode, Level1, Level2):-
    repeat, 
    once(valid_moves(1, ListOfMoves1)),
    once(value(Value1, ListOfMoves1)),
    once(value2(ListOfMoves1, 1, _, _)),

    if_then_else(
        Value1 == 0,
        write('\n Game Has Won , no more Possible Moves Available\n'),
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
checkMove(Row, Column, ErrorType, Player):-
 
    checkPlayerPieceColorStash(Row, Column, ErrorType , Player),
    (ErrorType == 0 ->
        (  (Row > 0, Row < 12, Column > 0, Column < 13) -> checkRules(Row, Column, ErrorType);
        ErrorType = 4)
    ; true
    ),
    

=======
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
%   Returns one of the best of the valid moves
value2(ListOfMoves, Player, Row, Column):-
    initialBoard(Board),
    addValueForEachMove(Player, Board).

%   Returns the list of valid moves of a certain board
valid_moves(Player, ListOfMoves, Board) :-
    findall([Row,Column], iterateBoard(Board, Row, Column, Player), ListOfMoves).
   % write('Possible Moves: '), write(ListOfMoves).


%   Returns the list of valid moves
valid_moves(Player, ListOfMoves) :-
    initialBoard(Board),
    findall([Row,Column], iterateBoard(Board, Row, Column, Player), ListOfMoves).
    %write('Possibe Moves: '), write(ListOfMoves).

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
>>>>>>> Stashed changes
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
    Hout = nullCell,
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