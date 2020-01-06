:- use_module(library(lists)).
:- use_module(library(between)).
:-dynamic film/4.

%title, categories, duration, voting
film('Doctor Strange', [action, adventure, fantasy], 115, 7.6).
film('Hacksaw Ridge', [biography, drama, romance], 131, 8.7).
film('Inferno', [action, adventure, crime], 121, 6.4).
film('Arrival', [drama, mystery, scifi], 116, 8.5).
film('The Accountant', [action, crime, drama], 127, 7.6).
film('The Girl on the Train', [drama, mystery, thriller], 112, 6.7).

%username, yearofbirth, country
user(john, 1992, 'USA').
user(jack, 1989, 'UK').
user(peter, 1983, 'Portugal').
user(harry, 1993, 'USA').
user(richard, 1982, 'USA').

%username, film-rating
vote(john, ['Inferno'-7, 'Doctor Strange'-9, 'The Accountant'-6]).
vote(jack, ['Inferno'-8, 'Doctor Strange'-8, 'The Accountant'-7]).
vote(peter, ['The Accountant'-4, 'Hacksaw Ridge'-7, 'The Girl on the Train'-3]).
vote(harry, ['Inferno'-7, 'The Accountant'-6]).
vote(richard, ['Inferno'-10, 'Hacksaw Ridge'-10, 'Arrival'-9]).

% 13
minJogadas(Ini, Final, N):-
    verifyMinJogadas(Ini, Final, 0, N).

verifyMinJogadas(Ini, Final, CurrN, CurrN):- 
    podeMoverEmN(Ini, CurrN, Cells), 
    member(Final, Cells), !.
verifyMinJogadas(Ini, Final, CurrN, N):- 
    NextN is CurrN + 1, 
    verifyMinJogadas(Ini, Final, NextN, N).
    
% 12
podeMoverEmN(Ini, N, Cells):-
    podeMoverEmNJogadas([Ini], N, UnsortedCells),
    sort(UnsortedCells, Cells).

podeMoverEmNJogadas(StartPositions, 0, StartPositions).
podeMoverEmNJogadas(StartPositions, N, Cells):-
    N > 0,
    N1 is N - 1,
    podeMoverEmNJogadas(StartPositions, N1, SubCells),
    findall(Move, (member(X, SubCells), validmove(X, Move)), CurrCells),
    append(SubCells, CurrCells, Cells).

% 11
move(Ini, Positions):- 
    findall(Pos, validmove(Ini, Pos), Positions).

validmove(X/Y, Xf/Yf):- 
    move(Xmoved/Ymoved),
    Xf is X + Xmoved,
    Yf is Y + Ymoved,
    insideboard(Xf/Yf).

insideboard(X/Y):- 
    between(1, 8, X), between(1, 8, Y).

move(1 / 2).
move(1 / -2).
move(2 / 1).
move(-2 / 1).
move(-1 / -2).
move(-1 / 2).
move(-2 / -1).
move(2 / -1).

% 10
% what(Username,Result) :-
%     vote(Username, RatingList),!,
%     findall(Rating, member(Film-Rating, RatingList), RatingsList),
%     length(RatingsList, Length),
%     sumlist(RatingsList, Sum),
%     Result is Sum/Length.
% Este predicado recebe o username como argumento,
% produz uma lista dos ratings dados pelo user para 
% a lista RatingsList. Depois calcula a soma de todos
% os elementos dessa lista e o seu tamanho, retornando
% em Result a soma desses ratings a dividir pelo tamanho da lista

% 9
update(Filme) :-
    retract(film(Filme, _, _, Score)),
    findall(
        RatingN, 
        (
            vote(_, RatingsN),
            member(Filme-RatingN, RatingsN)
        ),
        FilmRatingsList
    ),
    sumlist(FilmRatingsList, RatingsSum),
    length(FilmRatingsList, Size),
    NewScore is RatingsSum/Size,
    assert(film(Film, _, _, NewScore)).

% 8
calculateAvgDiff(User1, User2, AvgDiff) :-
    findall(
        RatingDiff,
        (
            vote(User1, User1Ratings),
            member(Film-Rating1, User1Ratings),
            vote(User2, User2Ratings),
            member(Film-Rating2, User2Ratings),
            RatingDiff is abs(Rating1-Rating2)
        ), 
        RatingsDifference
    ),
    sumlist(RatingsDifference, Sum),
    length(RatingsDifference, Length),
    AvgDiff is Sum/Length.


distancia(User1, Distancia, User2) :-
    user(User1, Year1, Country1),
    user(User2, Year2, Country2),
    calculateAvgDiff(User1, User2, AvgDiff),
    AgeDiff is abs(Year1-Year2), !,
    (
        (Country1 \= Country2, CountryDiff = 2) ; CountryDiff = 0   
    ),
    Distancia is AvgDiff + AgeDiff/3 + CountryDiff.

% 7
mostSimilar(Film, Similarity, Films) :-
    findall(
        Similarity,
        (
            similarity(Film, Film2, Similarity),
            Film2 \= Film
        ),
        SimilarityScores
    ),

    max_member(SimilarityScores, MostSimilar),

     findall(
         Film2Similar,
        (
            similarity(Film, Film2Similar, Similarity),
            Similarity == MostSimilar
        ),
        Films
    ).
% 6
similarity(Film1, Film2, Similarity) :-
    film(Film1, Categories1, Dur1, Score1),
    film(Film2, Categories2, Dur2, Score2),
    elemsComuns(Categories1, ListCommons, Categories2),
    length(Categories1, SizeCat1),
    length(Categories2, SizeCat2),
    length(ListCommons, SizeCommon),
    AllElementsSize is (SizeCat1+SizeCat2)-SizeCommon,
    PercentCommonCat is (SizeCommon/AllElementsSize)*100,
    DurDiff is abs(Dur1-Dur2),
    ScoreDiff is abs(Score1-Score2),
    Similarity is PercentCommonCat - 3*DurDiff - 5*ScoreDiff.
% 5
printCategory(Category) :-
    (
        film(Title, Categories, Duration, Voting),
        member(Category, Categories),
        format('~s (~dmin, ~2f/10\n', [Title, Duration, Voting]),
        fail
    ) ; true.

% 4
elemsComuns([], [], _).
elemsComuns([H|T], [H | OtherCommons], List2) :-
    member(H, List2),
    elemsComuns(T, OtherCommons, List2).
elemsComuns([H|T], OtherCommons, List2) :-
    elemsComuns(T, OtherCommons, List2).
% 3
niceGuy(User) :-
    vote(User, Ratings),
    member(_-Score, Ratings),
    Score >= 8.
% 2
diff(User1, User2, Difference, Film) :-
    vote(User1, Ratings1),
    vote(User2, Ratings2),
    member(Film-Score1, Ratings1),
    member(Film-Score2, Ratings2),
    Difference is abs(Score1-Score2).
% 1
curto(Movie) :-
    film(Movie, _, Duration, _),
    Duration < 125.


