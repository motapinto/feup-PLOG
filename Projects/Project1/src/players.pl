

:- dynamic player1/1.
:- dynamic player2/1.


% R Y B
player1([0, 0, 0]).
player2([0, 0, 0]).

initializePlayers(Player1Pieces, Player2Pieces):-
    player1(Player1Pieces),
    player2(Player2Pieces).

colorPiece(red, 1).
colorPiece(yellow, 2).
colorPiece(blue, 3).

printPlayersScoreLine([], 4).

printPlayersScoreLine([H|T], Column) :-
    ColumnN is Column + 1,
    ((Column == 1,
    write('Numbers of reds -->'));
    (Column == 2,
    write('Numbers of yellows -->'));
    (Column == 3,
    write('Numbers of blues -->'))) ,
    write(H),
    write('\n'),
    printPlayersScoreLine(T, ColumnN).


printPlayer1Score(Player1Pieces):-
    write('Player 1 score:\n'),
    printPlayersScoreLine(Player1Pieces, 1).

printPlayer2Score(Player2Pieces):-
    write('Player 2 score:\n'),
    printPlayersScoreLine(Player2Pieces, 1).
    
printPlayersCurrentScore:-
    initializePlayers(Player1Pieces, Player2Pieces),
    printPlayer1Score(Player1Pieces),
    printPlayer2Score(Player2Pieces).    
    

addPieceToPlayer(1, [H | T], [Hout | T]):-
    H < 5,
    Hout is H + 1.

addPieceToPlayer(Column , [H|T], [H | Tout]):-
    Column > 1,
    ColumnN is Column - 1, 
    addPieceToPlayer(ColumnN, T, Tout).

addPieceToWhatPlayer(PlayerNumber, PieceColor):-
    colorPiece(PieceColor, Index),

    (PlayerNumber == 1 -> 
        (retract(player1(Player1Pieces)),
        addPieceToPlayer(Index, Player1Pieces, Player1PiecesOut),
        assert(player1(Player1PiecesOut))) ;  
        
       (retract(player2(Player2Pieces)),
        addPieceToPlayer(Index, Player2Pieces, Player2PiecesOut),
        assert(player2(Player2PiecesOut)))
    ).

