:- [board].

checkRules(Row, Column, ErrorType):-
    checkIfNotNull(Row, Column, ErrorType).

%checkifPiecesAreSafe(Row, Column):-
    
 %   retract(initialBoard(BoardIn)),
  %  removePiece(BoardIn, BoardOut, Row, Column),
   % assert(initialBoard(BoardOut)),
  %  PreviousRow is Row - 1,
  %  NextRow is Row + 1,
   % PreviousColumn is Column - 1,
  %  NextColumn is Column + 1,
   % (
    %    (checkIfPieceIsSafe(PreviousRow, PreviousColumn),
     %   checkIfPieceIsSafe(PreviousRow, Column),
      %  checkIfPieceIsSafe(Row, PreviousColumn),
     %   checkIfPieceIsSafe(Row, NextColumn),
      %  checkIfPieceIsSafe(NextRow, PreviousColumn),
      %  checkIfPieceIsSafe(NextRow, Column),
      %  )-> true;
      %  (retract(initialBoard(_)),
      % assert(initialBoard(BoardIn)),
      %  fail)
    %).

    

%checkIfPieceIsSafe(Row, Column, Board):-
    %verificar se a peça está fora do bord ou na borda do bord, erro ao ir verifcar a lista
    %verifcar se a peça é null
    %verificar se as peças adjacentes das peças não null 
    


checkIfNotNull(Row, Column, ErrorType) :-
    initialBoard(In),
    checkRow(Row, Column, In, ErrorType).

checkColumn(1, [H|T], ErrorType):-
    (
        H == nullCell ->
        ErrorType = 1; 
        ErrorType = 0
    ).

checkColumn(Column, [H|T] , ErrorType):-
    Column > 1,
    ColumnI is Column - 1, 
    checkColumn(ColumnI, T, ErrorType).

checkRow(1, Column, [H|T], ErrorType):-
    checkColumn(Column, H, ErrorType).
    
checkRow(Row, Column, [H|T] , ErrorType):-
    Row > 1,
    RowNext is Row - 1, 
    checkRow(RowNext, Column, T, ErrorType).