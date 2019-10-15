printMoveOption :-
    write('=> (1) Add piece'), nl,
    write('=> (2) Remove Piece'), nl,
    write('=> (3) Quit'), nl.

moveInputHandler :-
    read(Input),
    (
        Input == 1, addPieceMove; 
        Input == 2, removePieceMove;
        selectMove
    ).

selectMoveOption :-
    write('> Insert your option: '),
        moveInputHandler.
    
selectMove :-
    printMoveOption,
    selectMoveOption.

addPieceMove :-
    write('> Adding piece...\n'),
    write('> Select row: '),
    read(Row), 
    write('n> Select column: '),
    read(Column),
    write('n> Select piece(R/B/Y): '),
    read(Piece),
    checkMove(Row, Column, Piece).

    %addPiece(Row, Column, Piece)

removePieceMove :-
    write('> Removing piece...\n'),
    write('> Select row: '),
    read(Row), 
    write('> Select column: \n'),
    read(Column),
    checkMove(Row, Column, '-').
    %canRemovePiece(Row, Column) - faz check e depois chama add piece com S = '-'
    %addPiece(Row, Column, '-')


checkMove(Row, Column, Piece) :-
    (
        Row > 0, Row < 12,
        Column > 0, Column < 13,
        piece(X, Piece)

    ) ; 
    write('Invalid play move\n\n'),
    selectMove.
