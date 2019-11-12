

iterateThroughListOfMoves([], NumberOfMovesPossibleAux, NumberOfMovesPossible):-
    NumberOfMovesPossible = NumberOfMovesPossibleAux.

iterateThroughListOfMoves([_|T],  NumberOfMovesPossibleAux, NumberOfMovesPossible):-
    NumberOfMovesPossibleAux1 is NumberOfMovesPossibleAux + 1,
    iterateThroughListOfMoves(T, NumberOfMovesPossibleAux1, NumberOfMovesPossible).


value(Player, Value):-
    valid_moves(Player, ListOfMoves),
    iterateThroughListOfMoves(ListOfMoves, 0, Value).


valid_moves(Player, ListOfMoves) :-
    checkAll(1, 1, Player, _, ListOfMoves, 0).


choosePieceToRemove(Row, Column, CounterRet, ListOfMoves):-
    if_then_else(
        CounterRet == 1,
        Value = 1,
        random(1, CounterRet, Value)
    ),
    iteratePossibleMoves(Row, Column, Value, ListOfMoves).

iterateColumn(Column, [H|_]):-
    Column = H.

iterateRow(Row, Column, [H | T]):-
    Row = H,
    iterateColumn(Column, T).

iteratePossibleMoves(Row, Column, 1, [H|_]):-
    iterateRow(Row, Column, H).
    
iteratePossibleMoves(Row, Column, Value, [_|T]):-
    Value1 is Value - 1,
    iteratePossibleMoves(Row, Column, Value1, T).

%   Checks all possible moves for each player
checkAll(Row, Column, Player, Moves, MovesRet, Counter) :-
    %   Checks if play is legal for Row and Column
    if_then_else(
        checkRules(Row, Column, Player, 1),
        (
            addPossibleMove(Row, Column, Moves , MovesAux),
            if_then_else(
                nextPos(Row, Column, RowN, ColumnN),
                (
                    CounterAux is Counter + 1,
                    checkAll(RowN, ColumnN, Player, MovesAux, MovesRet, CounterAux)
                ),
                MovesRet = Moves
            )
        ), 
        if_then_else(
                nextPos(Row, Column, RowN, ColumnN),
                checkAll(RowN, ColumnN, Player, Moves, MovesRet, Counter),
                (
                    if_then_else(
                        Counter >= 1,
                        (
                            MovesRet = Moves
                        ),
                        true
                    )
                )
        )
    ).
    %   Checks next position in the board -> when reaches the end of the board returns fail



addPossibleMove(Row, Column, Moves, Moves1):-
    append(Moves, [[Row, Column]], Moves1).
    

%   Decides next possition to check
nextPos(Row, Column, RowN, ColumnN) :-
    if_then_else(
        Column < 12, 
        (
            RowN = Row,
            ColumnN is Column + 1
        ),
        (
            ColumnN = 1,
            RowN is Row + 1,
            if_then_else(RowN > 11, fail, true)
        )
    ).
