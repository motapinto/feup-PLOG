:- dynamic player1/1.
:- dynamic player2/1.

%        R, Y, B
player1([5, 5, 4]).
player2([4, 5, 5]).

colorPiece(red, 1).
colorPiece(yellow, 2).
colorPiece(blue, 3).

%   Inicializes the players pieces
initializePlayers(Player1Pieces, Player2Pieces):-
    player1(Player1Pieces),
    player2(Player2Pieces).

%   Prints players stash
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

%   Prints player 1 stash
printPlayer1Score(Player1Pieces):-
    write('Player 1 score:\n'),
    printPlayersScoreLine(Player1Pieces, 1).

%   Prints player 2 stash
printPlayer2Score(Player2Pieces):-
    write('Player 2 score:\n'),
    printPlayersScoreLine(Player2Pieces, 1).
    
%   Prints the 2 players stash 
printPlayersCurrentScore:-
    initializePlayers(Player1Pieces, Player2Pieces),
    printPlayer1Score(Player1Pieces),
    printPlayer2Score(Player2Pieces).    
    
%   Adds a piece to a player
addPieceToPlayer(1, [H | T], [Hout | T]):-
    Hout is H + 1.
addPieceToPlayer(Column , [H|T], [H | Tout]):-
    Column > 1,
    ColumnN is Column - 1, 
    addPieceToPlayer(ColumnN, T, Tout).

%   Adds a piece to a player and dynamically change it's stash
addPieceToWhatPlayer(PlayerNumber, PieceColor):-
    colorPiece(PieceColor, Index),

    %   If the PlayerNumber == 1 doesnt need to check the other condition
    %   They are mutually exclusive, only one can succed
    ((
        PlayerNumber == 1, !,
        retract(player1(Player1Pieces)),
        addPieceToPlayer(Index, Player1Pieces, Player1PiecesOut),
        assert(player1(Player1PiecesOut))   
    ) 
        ;
    (
        PlayerNumber == 2, !,
        retract(player2(Player2Pieces)),
        addPieceToPlayer(Index, Player2Pieces, Player2PiecesOut),
        assert(player2(Player2PiecesOut))
    )). 

%   Check if player has reached the amount of 5 pieces per color
checkPlayerPieces(4, [], 1).
checkPlayerPieces(Column , [H|T], Exit):-
    ColumnN is Column + 1, 
    (
        H == 5, !, checkPlayerPieces(ColumnN, T, Exit)
    )
    ;
    (
        Exit = 0
    ).

%   Checks if both players have reached the amount of 5 pieces per color
checkIfPlayersHaveWon(ExitGame):-
    player1(Player1Pieces),
    checkPlayerPieces(1, Player1Pieces, Exit1),
    player2(Player2Pieces),
    checkPlayerPieces(1, Player2Pieces, Exit2),
    (
        (Exit1 == 0 ; Exit2 == 0), !, ExitGame = 0
    )
    ;
    (
        write('THE PLAYERS HAVE WON THE GAME \n'), ExitGame = 1
    ).

%   Checks if player has reached the limit for a piece color before adding the piece to player's stash
checkPlayerPieceColorStash(Row, Column, ErrorType, Player):-
    initialBoard(Board),
    returnColorPiece(Row, Column, Board, Color),
    colorPiece(Color, Index),
    (Player == 1 ->   player1(PlayerPieces) ; player2(PlayerPieces)),
    checkPlayersStashForColor(PlayerPieces, Index, ErrorType).

%   Checks if player has reached the limit for a piece color
checkPlayersStashForColor([H|T], 1, ErrorType):-
    H == 5 -> ErrorType = 5; ErrorType = 0.
checkPlayersStashForColor([H|T], Column, ErrorType):-
    ColumnN is Column - 1, 
    checkPlayersStashForColor(T, ColumnN, ErrorType).




   
