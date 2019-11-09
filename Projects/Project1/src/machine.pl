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
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FIRST POSSIBLE MOVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Returns first possible move from possibleMovesPX from player
firstPossibleMove(Row, Column, Player) :-
    if_then_else(
        Player == 1,
        (
            %   Player 1
            possibleMovesP1(Init),
            checkRow(Init, Row, Column, 0)
        ),
        (
            %   Player 2
            possibleMovesP2(Init),
            checkRow(Init, Row, Column, 0) 
        ) 
    ).

%   Checks first column in received row that as a possible move
checkCol([H|T], Column, Counter):-
    CounterN is Counter + 1,

    if_then_else(
        H == y, 
        (true, Column = CounterN),
        checkCol(T, Column, CounterN)
    ).

%   Checks first row in which there is a column that as a possible move
checkRow([H|T], Row, Column, Counter):-
    CounterN is Counter + 1,

    if_then_else(
        checkCol(H, Column, 0),
        (true, Row = CounterN),
        checkRow(T, Column, Row, CounterN)
    ).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ADDS A POSSIBLE MOVE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Updates possibleMovesPX depending on the player
addPossibleMove(Row, Column, Player) :-
    if_then_else(
        Player == 1,
        (
            %   Player 1
            retract(possibleMovesP1(Before)),
            addMove(Before, After, Row, Column),
            assert(possibleMovesP1(After))
        ),
        (
            %   Player 2
            retract(possibleMovesP1(Before)),
            addMove(Before, After, Row, Column),
            assert(possibleMovesP1(After))
        ) 
    ).
%   Adds possible move to possibleMovesPX from player
addMove(Before, After, Row, Column) :-
    updateRowPossibleMoves(Row, Column, Before, After).

%   Iterates through the columns of the possibleMovesPX, adding the possible move to possibleMovesPX
updateColumnPossibleMoves(1, [H|T], [Hout|T]):-
    Hout = y.
updateColumnPossibleMoves(Column, [H|T], [H|Tout]):-
    Column > 1,
    ColumnI is Column - 1, 
    updateColumnPossibleMoves(ColumnI, T, Tout).

%   Iterate through the rows of the possibleMovesPX 
updateRowPossibleMoves(1, Column, [H|T], [Hout|T]):-
    updateColumnPossibleMoves(Column, H, Hout).    
updateRowPossibleMoves(Row, Column, [H|T], [H|Tout]):-
    Row > 1,
    RowNext is Row - 1, 
    updateRowPossibleMoves(RowNext, Column, T, Tout).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
