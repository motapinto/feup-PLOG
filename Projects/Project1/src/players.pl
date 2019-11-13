:- dynamic player1/1.
:- dynamic player2/1.

%   Players stashes (R Y B)
player1([0, 0, 0]).
player2([0, 0, 0]).

%   Used to parse the color of a piece to a index in the players Stash
colorPiece(r, 0).
colorPiece(y, 1).
colorPiece(b, 2).

%   Switch to print player's score alongside the board
switchPlayerScore(4, _, _) :-
    write('            Player1             Player2').

switchPlayerScore(5, Player1, Player2) :-
    nth0(0, Player1, Red1),
    nth0(0, Player2, Red2), 
    format('             >Red:~d', [Red1]),
    format('              >Red:~d', [Red2]).

switchPlayerScore(6, Player1, Player2) :-
    nth0(1, Player1, Yellow1),
    nth0(1, Player2, Yellow2),
    format('            >Yellow:~d', [Yellow1]),
    format('           >Yellow:~d', [Yellow2]).

switchPlayerScore(7, Player1, Player2) :-
    nth0(2, Player1, Blue1),
    nth0(2, Player2, Blue2),
    format('             >Blue:~d', [Blue1]),
    format('             >Blue:~d', [Blue2]).

%   Prints both players score
printPlayersScore(Line):-
    player1(Player1Pieces),
    player2(Player2Pieces),
    if_then_else(
        switchPlayerScore(Line, Player1Pieces, Player2Pieces),
        true,
        true
    ).
    

%   Adds 1 piece of PieceColor color to the player PlayerNumber stash 
addPieceToWhatPlayer(PlayerNumber, PieceColor):-
    colorPiece(PieceColor, Index),

    if_then_else(
        PlayerNumber == 1, 
        (
            retract(player1(Player1Pieces)),
            incrementElemInList(Index, Player1Pieces, Player1PiecesOut),
            assert(player1(Player1PiecesOut))
        ), 
        (
            retract(player2(Player2Pieces)),
            incrementElemInList(Index, Player2Pieces, Player2PiecesOut),
            assert(player2(Player2PiecesOut))
        )
    ).

%   Checks if a specific position in the player stash has reached it's limit
iterateStashElem(Column, List):-
    nth0(Column, List, Elem),
    if_then_else(
        Elem == 5, 
        (! , fail), 
        true
    ).

%   Checks if when trying to add a piece to the player's stash, if 
%   the maximum amount of pieces of that color has been reached
checkPieceLimit(Color, Player):-
    if_then_else(Player == 1, player1(PlayerPieces),  player2(PlayerPieces)),
    colorPiece(Color, Column),
    iterateStashElem(Column, PlayerPieces).

%   Checks if all positions in the player stash has reached it's limit
iteratePlayerPieces(List):-
    \+iterateStashElem(0, List), !,
    \+iterateStashElem(1, List), !,
    \+iterateStashElem(2, List), !.

%   Checks if both players have 5 pieces of each color, then the game ends
checkIfPlayersHaveWon:-
    player1(Player1Pieces),
    if_then_else(
        iteratePlayerPieces(Player1Pieces),
        (
            player2(Player2Pieces),
            if_then_else(
                iteratePlayerPieces(Player2Pieces),
                true,
                (!, fail)       
            )
        ),
        (!, fail)
    ).
