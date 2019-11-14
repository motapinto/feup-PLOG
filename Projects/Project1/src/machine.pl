%   Generate random move
randomMove(Row, Column) :-
    random(1, 12, Row),
    random(1, 13, Column).

%   Randomizes a position to remove from the list of possible moves
choosePieceToRemove(Row, Column, ListOfMoves):-
    value(NumberOfValidMoves, ListOfMoves),
    random(0, NumberOfValidMoves, Pos),
    selectElement(Row, Column, Pos, ListOfMoves).

%  Selects the Pos element from ListOfMoves
selectElement(Row, Column, Pos, ListOfMoves):-
    nth0(Pos, ListOfMoves, Element),
    nth0(0, Element, Row),
    nth0(1, Element, Column).

simulateTakePiece(Row, Column, ElemI, Player, Board, BoardOut, NewListOfMovesPrev, NewListOfMovesAfter) :-
    valid_moves(Player, ListOfMovesBefore, Board),
    write('Board In: '), write(Board), nl, nl,
    write('ListOfMovesBefore: '), write(ListOfMovesBefore),  nl,  nl,
    
    removePiece(Board, Out, Row, Column, _),
    write('Board Out: '), write(Out), nl,  nl,
    
    valid_moves(Player, ListOfMovesAfter, Out),
    value(NumOfMoves, ListOfMovesAfter),
    write('ListOfMovesAfter: '), write(ListOfMovesAfter),  nl,  nl,
    write('NumOfMoves: '), write(NumOfMoves),  nl,  nl,
    
    %   Updates the third paramater for each element in list of possibel moves (number of resulting possible moves after taking piece)
    nth0(ElemI, ListOfMovesBefore, Elem),
    write('Elem: '), write(Elem), nl,  nl,
    append(Elem, NumOfMoves, NewElem),
    write('NewElem: '), write(NewElem), nl,  nl,
    append(NewListOfMovesPrev, NewElem, NewListOfMovesAfter),
    write('NewListOfMoves: '), write(NewListOfMovesAfter), nl,  nl.


addValueForEachMove(Player, Board) :-
    simulateTakePiece(1, 1, 0, Player, Board, BoardOut, [], NewListOfMovesAfter),
    simulateTakePiece(1, 3, 1, Player, BoardOut, BoardOut2, NewListOfMovesAfter, NewListOfMovesAfter2),
    write(NewListOfMovesAfter2), nl.