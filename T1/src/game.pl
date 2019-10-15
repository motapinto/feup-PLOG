selectMove :-
    write('> Insert your option: '),
        moveHandler.

moveHandler :-
    read(Input),
    (
        Input == 1, addPiece();
        Input == 2, removePiece()
        Input > 2, selectMove ; Input < 1, selectMove
    ).
