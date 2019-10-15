%include library's
:- [board].
:- [rules].

%   Prints different options for the next move type
printMoveOption :-
    write('=> (1) Add piece'), nl,
    write('=> (2) Remove Piece'), nl,
    write('=> (3) Quit'), nl.

%   Handles user input for the next move type
moveInputHandler :-
    read(Input),
    (
        Input == 1, addPieceMove; 
        Input == 2, removePieceMove;
        selectMove
    ).

%   Select move type option to be sent to moveInputHandler
selectMoveOption :-
    write('> Insert your option: '),
        moveInputHandler.

%   Print move option and store user input
selectMove :-
    printMoveOption,
    selectMoveOption.

%   Checks if a piece specified in Row and Column 
%   can be removed in the board game and if so remove piece
removePiece(Row, Column) :-
    %Checks if piece is protected

    %If it is not protected - can remove
    addPiece(Row, Column, '-').
    %If it is protected - check adjacent tiles


%   Asks for user input to decide specifics of
%   the play move, specifically row and column
removePieceMove :-
    write('> Removing piece...\n'),
    write('> Select row: '),
    read(Row), 
    write('> Select column: \n'),
    read(Column),
    
    checkMove(Row, Column, '-').
    removePiece(Row, Column). % faz check e depois chama add piece com S = '-'

%   Checks if a piece specified in Row and Column 
%   can be added in the board game and if so add piece
addPiece(Row, Column, Piece, Board) :-
    %Checks if position is empty

    %If it is empty - can add
    assert(initialBoard('Bob', 'Jane')).
    % cell(Row, Column, )
    %If it is not empty - send to selectMove

%   Asks for user input to decide specifics of
%   the play move, specifically row, column and piece
addPieceMove :-
    write('> Adding piece...\n'),
    write('> Select row: '),
    read(Row), 
    write('n> Select column: '),
    read(Column),
    write('n> Select piece(R/B/Y): '),
    read(Piece),
    checkMove(Row, Column, Piece),
    addPiece(Row, Column, Piece).

%   Checks if row, column and piece respect board 
%   limits and piece existance
checkMove(Row, Column, Piece) :-
    (
        Row > 0, Row < 12,
        Column > 0, Column < 13,
        piece(X, Piece)

    ) ; 
    write('Invalid play move\n\n'),
    selectMove.

%   Starts players vs player mode
startPVP :-
    write('PLayer1:\n'),
    selectMove,
    write('\n\nPLayer2:\n'),
    selectMove.
