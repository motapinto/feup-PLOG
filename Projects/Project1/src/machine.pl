
%   Randomizes a position to remove from the list of possible moves
choosePieceToRemove(Row, Column, CounterRet, ListOfMoves):-
    value(NumberOfValidMoves, ListOfMoves),
    random(0, NumberOfValidMoves, Pos),
    selectElement(Row, Column, Pos, ListOfMoves).

%  Selects the Pos element from ListOfMoves
selectElement(Row, Column, Pos, ListOfMoves):-
    nth0(Pos, ListOfMoves, Element),
    nth0(0, Element, Row),
    nth0(1, Element, Column).
