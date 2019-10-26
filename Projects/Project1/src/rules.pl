:- [board].

checkIfNotNull(Row, Column, ErrorType):-
    initialBoard(In),
    checkRow(Row, Column, In, ErrorType).


checkRules(Row, Column, ErrorType):-
    ErrorType = 0,
    checkIfNotNull(Row, Column, ErrorType).

checkColumn(1, [H|T], ErrorType):-
    (H == nullCell ->
    ErrorType = 1,
    fail; true).

checkColumn(Column, [H|T] , ErrorType):-
    Column > 1,
    ColumnI is Column - 1, 
    checkColumn(ColumnI, T).

checkRow(1, Column, [H|T], ErrorType):-
    checkColumn(Column, H).
    
checkRow(Row, Column, [H|T] , ErrorType):-
    Row > 1,
    RowNext is Row - 1, 
    checkRow(RowNext, Column, T).