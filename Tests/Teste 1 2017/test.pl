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

% esta mallll
:- (dynamic hours/1).
:- (dynamic percentage/1).
hours(0).
percentage(0).

updatePlayer(Player, Game, Hours, Percentage) :-
    retract(hours(TimeBefore)),
    retract(percentage(PercentageBefore)),
    played(Player, Game, TimeBefore, PercentageBefore),
    TimeNow is TimeBefore + Hours,
    PercentageNow is PercentageBefore + Percentage,
    assert(hours(TimeNow)),
    assert(percentage(PercentageNow)).

% esta mallll
littleAchivement(Player, Games) :-
    played(Player, Game, _, Percentage),
    \+member(Game, Games),
    Percentage < 20,
    littleAchivement(Player, [Game | Games]).
littleAchivement(Player, []).

ageRange(MinAge, MaxAge, Players) :-
    findall(
        Player, 
        (player(Player, _, Age), Age >= MinAge, Age=<MaxAge), 
        Players
    ).

sumList([], 0).
sumList([H|T], Sum):-
    sumList(T, SumN),
    Sum is H + SumN.

averageAge(Game, AverageAge) :-
    findall(Age, (played(Player, Game, _, _), player(_, Player, Age)), AgePlayers),
    sumList(AgePlayers, Value),
    length(AgePlayers, Size),
    AverageAge is Value / Size.

%Esta mal
% sortByEfficency([H|T], Out) :-
% mostEffective(Game, Players) :-
%     findall(P, played(Player, Game, _, _), PlayersList),

whatDoesItDo(UserName) :-
    player(_, UserName, Age),!,
    \+(
        played(UserName, Game, _, _),
        game(Game,_,MinAge),
        MinAge>Age
    ).

%   Vê se para um username o jogador jogou um jogo
%   em que nao tinha idade suficiente para jogar visto
%   que tinha idade inferior a idade minima
%   O cut serve para apos ir buscar o player correspondente ao username
%   e executar o resto dos passos abaixo, se der fail nao fazer redo de player e terminar

% Uma lista de listas dinamica ou seja
% para o sexmeplo de cima seria algo assim:
% [[0,8,8,7,7],[0,2,4,4],[0,3,3],[0,1],[0]]

elemHasDist(MatDis, Row, Column, Dist):-

areFar(Dist, MatDis, Pares):-
    findall([Row/Column], elemHasDist(MatDis, Row, Column, Dist), List):-
    \+member([Column/Row], List).    

%player(Name, UserName, Age).
%played(Player, Game, HoursPlayed, PercentUnlocked)
%game(Name, Categories, MinAge).