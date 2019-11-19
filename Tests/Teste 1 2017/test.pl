:-use_module(library(lists)).
:- (dynamic played/4).

%player(Name, UserName, Age).
player('Danny', 'Best Player Ever', 27).
player('Annie', 'Worst Player Ever', 24).
player('Harry', 'A-Star Player', 26).
player('Manny', 'The Player', 14).
player('Jonny', 'A Player', 16).

%game(Name, Categories, MinAge).
game('5 ATG', [action, adventure, open-world, multiplayer], 18).
game('Carrier Shift: Game Over', [action, fps, multiplayer, shooter], 16).
game('Duas Botas', [action, free, strategy, moba], 12).

%played(Player, Game, HoursPlayed, PercentUnlocked)
played('Best Player Ever', '5 ATG', 3, 83).
played('Worst Player Ever', '5 ATG', 52, 9).
played('The Player', 'Carrier Shift: Game Over', 44, 22).
played('A Player', 'Carrier Shift: Game Over', 48, 24).
played('A-Star Player', 'Duas Botas', 37, 16).
played('Best Player Ever', 'Duas Botas', 33, 22).

achivedLittle(Player) :-
    played(Player, _, Hours, _),
    Hours < 10.

isAgeAppropriate(Name, Game) :-
    game(Game, _, MinAge),
    player(Name, _, Age),
    Age >= MinAge.


timePlayingGames(_, [], [], 0).
timePlayingGames(Player, [GameInit | GameRest], [Hours | ListOfTime], SumTimes) :-
    timePlayingGames(Player, GameRest, ListOfTime, CounterN),
    played(Player, GameInit, Hours, _),
    SumTimes is Hours + CounterN.

isOfCategory(Game, Cat) :-
    game(Game, CatList, _),
    member(Cat, CatList).

listGamesOfCategory(Cat):-
    (
        game(Game, _, Age),
        isOfCategory(Game, Cat),
        format('~s (~d)', [Game, Age]),nl,
        fail    
    );true.

updatePlayer(Player, Game, Hours, Percentage) :-
    retract(played(Player, Game, TimeBefore, PercentageBefore)),
    TimeNow is TimeBefore + Hours,
    PercentageNow is PercentageBefore + Percentage,
    assert(played(Player, Game, TimeNow, PercentageNow)).

littleAchivement(Player, GamesSearched, [Game | Games]) :-
    played(Player, Game, _, Percentage),
    \+member(Game, GamesSearched),
    Percentage < 20, 
    append(GamesSearched, Game, NewSearch),
    littleAchivement(Player, NewSearch, Games).
littleAchivement(Player, _, []).
littleAchivement(Player, List) :-
    littleAchivement(Player, [], List).

ageRange(MinAge, MaxAge, Players) :-
    findall(
        Player, 
        (player(Player, _, Age), Age >= MinAge, Age=<MaxAge), 
        Players
    ).

averageAge(Game, AverageAge) :-
    findall(Age, (played(Player, Game, _, _), player(_, Player, Age)), AgePlayers),
    sumlist(AgePlayers, Value),
    length(AgePlayers, Size),
    AverageAge is Value / Size.

mostEffectivePlayers(Game, Players) :-
    findall(
        Ratio, 
        (
            played(Player, Game, Hour, Percentage),
            Ratio is Percentage / Hour
        ), 
        RatiosList
    ),
    max_member(Max, RatiosList),
    findall(
        Player2, 
        (
            played(Player2, Game, Hour2, Percentage2),
            \+member(Player2, Players), 
            Ratio2 is Percentage2 / Hour2, Ratio2 == Max
        ), 
        Players
    ).




%   Pergunta 10
%   Vê se para um username o jogador jogou um jogo
%   em que nao tinha idade suficiente para jogar visto
%   que tinha idade inferior a idade minima
%   O cut serve para apos ir buscar o player correspondente ao username
%   e executar o resto dos passos abaixo, se der fail nao fazer redo de player e terminar

%   Pergunta 11
% Uma lista de listas dinamica ou seja
% para o exemplo de cima seria algo assim:
% [[0,8,8,7,7],[0,2,4,4],[0,3,3],[0,1],[0]]

% ESTA MAL tudo para baixo --------------------
initialBoard([
    [0,8,8,7,7],
    [8,0,2,4,4],
    [8,2,0,3,3],
    [7,4,3,0,1],
    [7,4,3,1,0]
]).

elemHasDist(MatDis, Row, Column, Dist):-
    nth1(Row, MatDis, ColumnList),
    nth1(Column, ColumnList, Elem), !,
    Elem >= Dist.

nextPos(4,5,5,5).
nextPos(Row, Column, RowNext, ColumnNext) :-
    (Row < 5, RowNext is Row + 1);
    ColumnNext is Column + 1.

areFar(Dist, MatDis, Pares):-
    initialBoard(MatDis),
    findall([Row/Column], elemHasDist(MatDis, Row, Column, Dist), Pares),
    \+member([Column/Row], Pares).

%PERGUNTA 13
%PERGUNTA 14