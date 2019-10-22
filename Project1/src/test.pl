:- [board].

test :-
    initialBoard(Init),
    printBoard(Init),
    retract(initialBoard(Init)),
    removePiece(Init, Out, 2, 2),
    assert(initialBoard(Out)),
    printBoard(Out).

removePiece(In, Out, Row, Column) :-   
    atualizaLinha(Row, Column, In, Out).
    checkRules(Row, Column, In).

atualizaColuna(1, [H|T], [Hout|T]):-
    Hout = nullCell.

atualizaColuna(Column, [H|T], [H|Tout]):-
    Column > 1,
    ColumnI is Column - 1, 
    atualizaColuna(ColumnI, T, Tout).

atualizaLinha(1, Column, [H|T], [Hout|T]):-
    atualizaColuna(Column, H, Hout).
    
atualizaLinha(Row, Column, [H|T], [H|Tout]):-
    Row > 1,
    RowNext is Row - 1, 
    atualizaLinha(RowNext, Column, T, Tout).




    