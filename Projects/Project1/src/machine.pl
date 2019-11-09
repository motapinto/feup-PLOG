:-[rules].
:-[shared].

:- (dynamic possibleMovesP1/1).
:- (dynamic possibleMovesP2/1).

%   Initial Configuration of possibleMoves for player 1
possibleMovesP1([
    [n, n, n, n, n, n, n, n, n, n, n, n],
    [n, n, n, n, n, n, n, n, n, n, n, n],
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n],
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n]
]).

%   Initial Configuration of possibleMoves for player 2
possibleMovesP2([
    [n, n, n, n, n, n, n, n, n, n, n, n],
    [n, n, n, n, n, n, n, n, n, n, n, n],
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n],
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n], 
    [n, n, n, n, n, n, n, n, n, n, n, n]
]).

computePossibleMoves(Player) :-
    if_then_else(
        checkAll(1, 1, Player),
        true,                   %finished computation
        true
    ).

%   Checks all possible moves for each player
checkAll(Row, Column, Player) :-
    %   Checks if play is legal for Row and Column
    if_then_else(
        checkRules(Row, Column, Player, 1),
        addPossibleMove(Row, Column, Player), 
        true
    ),
    %   Checks next position in the board -> when reaches the end of the board returns fail
    if_then_else(
        nextPos(Row, Column, RowN, ColumnN),
        checkAll(RowN, ColumnN, Player),
        true
    ).

%   Decides next possition to check
nextPos(Row, Column, RowN, ColumnN) :-
    if_then_else(
        Column < 12, 
        (
            RowN = Row,
            ColumnN is Column + 1,
            if_then_else(ColumnN > 12, fail, true)
        ),
        (
            ColumnN = Column,
            RowN is RowN + 1,
            if_then_else(RowN > 11, fail, true)
        )
    ).

addPossibleMove(Row, Column, Player) :-
    if_then_else(
        Player == 1,
        (
            %   Player 1
            retract(possibleMovesP1(Before)),
            addMove(Before, After, Row, Column, Player),
            assert(possibleMovesP1(After))
        ),
        (
            %   Player 2
            retract(possibleMovesP1(Before)),
            addMove(Before, After, Row, Column, Player),
            assert(possibleMovesP1(After))
        ) 
    ).

%   Returns first possible move from possibleMovesPX from player
%firstPossibleMove(Row, Column, Player) :-

%   Adds possible move to possibleMovesPX from player
addMove(Before, After, Row, Column, Player) :-
    updateRowPossibleMoves(Row, Column, Before, After, Player).

%   Iterates through the columns of the possibleMovesPX, adding the possible move to possibleMovesPX
updateColumnPossibleMoves(1, [H|T], [Hout|T], Color):-
    Hout = y.
updateColumnPossibleMoves(Column, [H|T], [H|Tout], Color):-
    Column > 1,
    ColumnI is Column - 1, 
    updateColumnPossibleMoves(ColumnI, T, Tout, Color).

%   Iterate through the rows of the possibleMovesPX 
updateRowPossibleMoves(1, Column, [H|T], [Hout|T], Color):-
    updateColumnPossibleMoves(Column, H, Hout, Color).    
updateRowPossibleMoves(Row, Column, [H|T], [H|Tout], Color):-
    Row > 1,
    RowNext is Row - 1, 
    updateRowPossibleMoves(RowNext, Column, T, Tout, Color).