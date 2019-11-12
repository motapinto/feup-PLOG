:- (dynamic possibleMoves/1).

%   Initial Configuration of possibleMoves for player 1
possibleMoves([n]).


%   Initial Configuration of possibleMoves for player 2
initPossibleMoves:-
    retract(possibleMoves(_)),
    assert(possibleMoves([n])).

computePossibleMoves(Player, CounterRet) :-
    
    retract(possibleMoves(_)),
    checkAll(1, 1, Player, Moves, Moves1, 0, CounterRet),
    assert(possibleMoves(Moves1)), 
    write('Possible Moves: '),
    if_then_else(
        CounterRet > 0,
        write(Moves1),
        write('No moves \n')
    ),
    write('\n').

choosePieceToRemove(Row, Column, CounterRet):-
    random(1, CounterRet, Value),
    possibleMoves(Possible),
    write(Value),
    iteratePossibleMoves(Row, Column, Value, Possible).

iterateRowAndColumn(Row, Column, [H | T]):-
    Row = H,
    Column = T.

iteratePossibleMoves(Row, Column, 1, [H|T]):-
    iterateRowAndColumn(Row, Column, H).
    
iteratePossibleMoves(Row, Column, Value, [H|T]):-
    Value1 is Value - 1,
    iteratePossibleMoves(Row, Column, Value1, T).





%   Checks all possible moves for each player
checkAll(Row, Column, Player, Moves, MovesRet, Counter, CounterRet) :-
    %   Checks if play is legal for Row and Column
    if_then_else(
        checkRules(Row, Column, Player, 1),
        (
            addPossibleMove(Row, Column, Moves , MovesAux),
            if_then_else(
                nextPos(Row, Column, RowN, ColumnN),
                (CounterAux is Counter + 1,
                checkAll(RowN, ColumnN, Player, MovesAux, MovesRet, CounterAux, CounterRet)),
                (MovesRet = Moves, CounterRet = Counter, true)
            )
        ), 
        if_then_else(
                nextPos(Row, Column, RowN, ColumnN),
                checkAll(RowN, ColumnN, Player, Moves, MovesRet, Counter, CounterRet),
                (
                    if_then_else(
                        Counter >= 1,
                        (
                            MovesRet = Moves, 
                            CounterRet = Counter
                        ),
                        CounterRet = Counter
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
