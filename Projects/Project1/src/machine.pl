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
