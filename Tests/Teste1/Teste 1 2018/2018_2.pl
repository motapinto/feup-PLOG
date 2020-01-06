:- use_module(library(between)).
:- use_module(library(lists)).

% Name icao country
airport('Aeroporto Francisco Sá Carneiro', 'LPPR', 'Portugal').
airport('Aeroporto Humberto Delgado', 'LPPT', 'Portugal').
airport('Aeropuerto Adolfo Suárez Madrid-Barajas', 'LEMD', 'Spain').
airport('Aéroport de Paris-Charles-de-Gaulle Roissy Airport', 'LFPG', 'France').
airport('Aeroporto Internazionale di Roma-Fiumicino', 'LIRF', 'Italy').

% icao name year country
company('TAP', 'TAP Air Portugal', 1945, 'Portugal').
company('RYR', 'Ryanair', 1945, 'Portugal').
company('AFR', 'Société Air France S.A', 1933, 'France').
company('BAW', 'British Airways', 1974, 'United Kingdom').

% id origin dest departute duration company
flight('TP1923', 'LPPR', 'LPPT', 1115, 55, 'TAP').
flight('TP1968', 'LPPT', 'LPPR', 2235, 55, 'TAP').
flight('TP842', 'LPPT', 'LIRF', 1450, 195, 'TAP').
flight('TP843', 'LIRF', 'LPPT', 1935, 195, 'TAP').
flight('FR5483', 'LPPR', 'LEMD', 630, 105, 'RYR').
flight('FR5484', 'LEMD', 'LPPR', 1935, 105, 'RYR').
flight('AF1024', 'LFPG', 'LPPT', 940, 155, 'AFR').
flight('AF1025', 'LPPT', 'LFPG', 1310, 155, 'AFR').

dif_max_2(X, Y):- X < Y, X >= Y - 2.

make_max_pairs(L, P, S):-
    findall(Pairs, make_pairs(L, P, Pairs), ListOfPairLists),
    setof(Length-List, (member(List, ListOfPairLists), length(List, Length)), OrderedListOfPairLists),
    last(OrderedListOfPairLists, _MaxLen-S).

make_pairs(L, P, [X-Y|Zs]):-
    select(X, L, L2),
    select(Y, L2, L3),
    G =.. [P, X, Y], G,
    make_pairs(L3, P, Zs).

make_pairs(_, _, []).
% 8

numConnections(Company, Num):-
    findall(Country, companyIn(Company, Country), Countries),
    sort(Countries, SortedCountries),
    length(SortedCountries, Num).

mostInternational(ListOfCompanies):-
    findall(NumConnections-Company, (company(Company, _, _, _), numConnections(Company, NumConnections)), CompanyConnections),
    sort(CompanyConnections, SortedConnections),
    last(SortedConnections, BestValue-_BestCompany),
    findall(Company, member(BestValue-Company, SortedConnections), ListOfCompanies).

% 7
avgFlightLengthFromAirport(Airport, AvgLength):-
    findall(Length, flight(_, Airport, _, _, Length, _), Lengths),
    listavg(Lengths, AvgLength).

listavg([], _):- !, fail.
listavg(List, Avg):-
    sumlist(List, Sum),
    length(List, Len),
    Avg is Sum / Len.
    
% 6
tripDays([Country | Trip], Time, Times, Days):-
    makeTrip(Trip, Country, Time, 1, Times, Days).

makeTrip([], _, _, CurrDay, [], CurrDay).
makeTrip([Country | Trip], CurrCountry, CurrTime, CurrDay, [DepartureTime | Times], Days):-
    airport(_, AirportFrom, CurrCountry),
    airport(_, AirportTo, Country),
    flight(Flight, AirportFrom, AirportTo, DepartureTime, _, _),
    getNextDay(DepartureTime, CurrTime, CurrDay, NextDay),
    arrivalTime(Flight, ArrivalTime),
    makeTrip(Trip, Country, ArrivalTime, NextDay, Times, Days).

getNextDay(DepartureTime, CurrTime, CurrDay, CurrDay):- DepartureTime > CurrTime + 30, !.
getNextDay(_DepartureTime, _CurrTime, CurrDay, NextDay):- NextDay is CurrDay + 1.

% 5
pairable(Airport, Arrival, Departure):-
    flight(Arrival, _, Airport, _, _, _),
    flight(Departure, Airport, _, DepartureTime, _, _),
    arrivalTime(Arrival, ArrivalTime),
    timeDiff(DepartureTime, ArrivalTime, Diff),
    30 =< Diff, Diff =< 90.

timeDiff(Time1, Time2, Diff):-
    Hours1 is Time1 // 100,
    Hours2 is Time2 // 100,
    Minutes1 is Time1 mod 100,
    Minutes2 is Time2 mod 100,
    HourDiff is Hours1 - Hours2,
    MinuteDiff is Minutes1 - Minutes2,
    joinTimeDiffs(HourDiff, MinuteDiff, CorrectedHourDiff, CorrectedMinuteDiff),
    Diff is CorrectedHourDiff * 60 + CorrectedMinuteDiff.

joinTimeDiffs(HourDiff, MinuteDiff, HourDiff, MinuteDiff):- MinuteDiff > 0, !.
joinTimeDiffs(HourDiff, MinuteDiff, CorrectedHourDiff, CorrectedMinuteDiff):- 
    CorrectedHourDiff is HourDiff - 1,
    CorrectedMinuteDiff is MinuteDiff + 60.
    
pairableFlights:-
    pairable(Airport, Arrival, Departure),
    write(Airport), write(' - '), write(Arrival), write(' \\ '), write(Departure), nl,
    fail.
pairableFlights.

% 4
companyIn(Company, Country):- airport(, Orig, Country), flight(, Orig, _Dest, _, _, Company).
companyIn(Company, Country):- airport(, Dest, Country), flight(, _Orig, Dest, _, _, Company).
countries(Company, Countries):-
    getCountries(Company, [], AllCountries),
    remove_duplicates(AllCountries, Countries).

getCountries(Company, Acc, [Country | Countries]):-
    companyIn(Company, Country),
    \+member(Country, Acc), !,
    getCountries(Company, [Country | Acc], Countries).

getCountries(_Company, Acc, Acc).

remove_duplicates([], []).
remove_duplicates([X | L], [X | NL]):- remove_duplicates(L, NL), \+member(X, NL).
remove_duplicates([X | L], NL):- remove_duplicates(L, NL), member(X, NL).


% 3
arrivalTime(Flight, ArrivalTime):-
    flight(Flight, _, _, DepartureTime, Duration, _),
    DepHours is DepartureTime // 100,
    DepMinutes is DepartureTime mod 100,
    ArrivalHours is DepHours + (DepMinutes + Duration) // 60,
    ArrivalMinutes is (DepMinutes + Duration) mod 60,
    ArrivalTime is 100 * ArrivalHours + ArrivalMinutes.

% 2
shorter(Flight1, Flight2, ShorterFlight):-
    flight(Flight1, _, _, _, Duration1, _),
    flight(Flight2, _, _, _, Duration2, _),
    compareDurations(Flight1-Duration1, Flight2-Duration2, ShorterFlight-_).

compareDurations(Flight1-Duration1, _Flight2-Duration2, Flight1-Duration1):- Duration1 < Duration2.
compareDurations(_Flight1-Duration1, Flight2-Duration2, Flight2-Duration2):- Duration1 > Duration2.

% 1
short(Flight):-
    flight(Flight, _Origin, _Dest, _Dep, Duration, _Comp),
    Duration < 90.


whitoff(1, [1/1]).
whitoff(N, W):-
    N > 0,
    N1 is N - 1,
    whitoff(N1, SubW),
    getborders(N, Borders),
    findall(Winnable, (member(Winnable, Borders), letsSelfWin(Winnable, SubW)), Winnables),
    append(SubW, Winnables, W).

letsSelfWin(Position, Winnables):-
    validmoves(Position, OpponentMoves),
    allLetAdversaryWin(OpponentMoves, Winnables).

allLetAdversaryWin([], _).
allLetAdversaryWin([Move | Moves], Winnables):-
    letsAdversaryWin(Move, Winnables),
    allLetAdversaryWin(Moves, Winnables).

letsAdversaryWin(Move, Winnables):-
    validmoves(Move, Opponentmoves),
    contains_any_of(Opponentmoves, Winnables).

contains_any_of(L1, [X | _L2]):- member(X, L1), !.
contains_any_of(L1, [_X | L2]):- contains_any_of(L1, L2).

getborders(Dims, Borders):-
    findall(X/Y, (X = Dims, between(1, Dims, Y); Y = Dims, between(1, Dims, X)), Borders).

validmoves(Xi/Yi, Moves):-
    findall(Move, (validmove(Xi/Yi, Move), Move \= Xi/Yi), Moves).

validmove(Xi/Yi, Xf/Yi):- between(1, Xi, Xf).
validmove(Xi/Yi, Xi/Yf):- between(1, Yi, Yf).
validmove(Xi/Yi, Xf/Yf):- 
    Min is min(Xi, Yi),
    MinX is Xi - Min + 1, 
    MinY is Yi - Min + 1, 
    between(MinX, Xi, Xf),
    between(MinY, Yi, Yf),
    Diff is Xi - Xf,
    Diff is Yi - Yf.