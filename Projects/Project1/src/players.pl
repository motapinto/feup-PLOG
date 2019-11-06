:-[shared].

:- dynamic player1/1.
:- dynamic player2/1.

%   Players stashes (R Y B)
player1([0, 0, 0]).
player2([0, 0, 0]).

%   Used to translate the color of a piece to a index in the players Stash
colorPiece(r, 1).
colorPiece(y, 2).
colorPiece(b, 3).

%   Initializes both players Stash's
initializePlayers(Player1Pieces, Player2Pieces):-
    player1(Player1Pieces),
    player2(Player2Pieces).

%   Prints the score of one player in a organized fashion
printPlayersScoreLine([], 4).
printPlayersScoreLine([H|T], Column) :-
    ColumnN is Column + 1,
    if_then_else(Column == 1, write('Numbers of reds -->'), 
        if_then_else(Column == 2, write('Numbers of yellows -->'), 
            if_then_else(Column == 3, write('Numbers of blues -->'), true)
        )
    ),
    write(H),
    write('\n'),
    printPlayersScoreLine(T, ColumnN).

%   Prints the score of Player 1
printPlayer1Score(Player1Pieces):-
    write('Player 1 score:\n'),
    printPlayersScoreLine(Player1Pieces, 1).

%   Prints the score of Player 2
printPlayer2Score(Player2Pieces):-
    write('Player 2 score:\n'),
    printPlayersScoreLine(Player2Pieces, 1).

%   Prints the score of both Players
printPlayersCurrentScore:-
    initializePlayers(Player1Pieces, Player2Pieces),
    printPlayer1Score(Player1Pieces),
    printPlayer2Score(Player2Pieces).    
    
%   Adds 1 piece of a certain color to a player's stash 
addPieceToPlayer(1, [H | T], [Hout | T]):-
    Hout is H + 1.
addPieceToPlayer(Column , [H|T], [H | Tout]):-
    Column > 1,
    ColumnN is Column - 1, 
    addPieceToPlayer(ColumnN, T, Tout).


%   Adds 1 piece of PieceColor color to the player PlayerNumber stash 
addPieceToWhatPlayer(PlayerNumber, PieceColor):-
    colorPiece(PieceColor, Index),

    if_then_else(
        PlayerNumber == 1, 
        (
            retract(player1(Player1Pieces)),
            addPieceToPlayer(Index, Player1Pieces, Player1PiecesOut),
            assert(player1(Player1PiecesOut))
        ), 
        (
            retract(player2(Player2Pieces)),
            addPieceToPlayer(Index, Player2Pieces, Player2PiecesOut),
            assert(player2(Player2PiecesOut))
        )
    ).

%   Checks if both players have 5 pieces of each color, then the game ends
checkIfPlayersHaveWon:-
    player1(Player1Pieces),
    if_then_else(
        iteratePlayerPieces(3, Player1Pieces),
        (
            player2(Player2Pieces),
            if_then_else(
                iteratePlayerPieces(3, Player2Pieces),
                true,
                fail       
            )
        ),
        fail
    ).

%   Auxiliar predicates to the previous one that iterate through the player's stash searching
%   if all the maximum amount of pieces has been reached for each color
iteratePlayerPieces(1, [H|_]):-
    if_then_else(H == 5, true, fail).
iteratePlayerPieces(Column , [H|T]):-
    ColumnN is Column - 1, 
    if_then_else(H == 5, iteratePlayerPieces(ColumnN, T), fail).
   
%   Checks if when trying to add a piece to the player's stash, if the maximum amount of pieces of 
%   that color has been reached
checkPieceLimit(Color, Player):-
    if_then_else(Player == 1, player1(PlayerPieces),  player2(PlayerPieces)),
    colorPiece(Color, Index),
    iterateStash(Index, PlayerPieces).

%   Auxiliar predicates to previous one , that iterate through the player stashes
iterateStash(1, [H|_]):-
    if_then_else(H == 5, fail, (!, true)).
iterateStash(Column, [_|T]):-
    Column >  0,
    ColumnN is Column - 1, 
    iterateStash(ColumnN, T).


