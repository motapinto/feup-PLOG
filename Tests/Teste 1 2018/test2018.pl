:- use_module(library(lists)).

%airport(Name, ICAO, Country)
airport('Aeroporto Francisco Sá Carneiro', 'LPPR', 'Portugal').
airport('Aeroporto Humberto Delgado', 'LPPT', 'Portugal').
airport('Aeropuerto Adolfo Suárez aMadrid-Barajas', 'LEMD', 'Spain').
airport('Aéroport de Paris-Charles-de-Gaulle Roissy Airport', 'LFPG', 'France').
airport('Aeroporto Internazionale di Roma-Fumicino - Leonardo da Vinci', 'LIRF', 'Italy').

%company(ICAO, Name, Year Company)
company('TAP', 'TAP Air Portugal', 1945, 'Portugal').
company('RYR', 'Ryanair', 1984, 'Ireland').
company('AFR', 'Societe Air France', 1933, 'France').
company('BAW', 'British Airways', 1974, 'UK').

%flight(Designation, Origin, Destination, DepartureTime, Duration, Company)
flight('TP1923', 'LPPR', 'LPPT', 1115, 55, 'TAP').
flight('TP1968', 'LPPT', 'LPPR', 2235, 55, 'TAP').
flight('TP842', 'LPPT', 'LIRF', 1450, 195, 'TAP').
flight('TP843', 'LIRF', 'LPPT', 1935, 195, 'TAP').
flight('FR5483', 'LPPR', 'LEMD', 630, 105, 'RYR').
flight('FR5484', 'LEMD', 'LPPR', 1935, 105, 'RYR').
flight('AF1024', 'LFPG', 'LPPT', 940, 155, 'AFR').
flight('AF1025', 'LPPT', 'LFPG', 1310, 155, 'AFR').

short(Flight) :-
    flight(Flight, _, _, _, Duration, _),
    Duration < 130.

shorter(Flight1, Flight2, F) :-
    Flight1 \= Flight2,
    flight(Flight1, _, _, _, D1, _),
    flight(Flight2, _, _, _, D2, _),
    (
        D1 < D2 -> F = Flight1 ; F = Flight2
    ).

flightTime(Init, Duration, Final) :-
    MinInit is Init mod 100,
    HourInit is Init - MinInit,
    MinFinal is (MinInit + Duration) mod 60,
    HoursFinal is (MinInit + Duration) // 60,
    Final is Init + 100*HoursFinal - MinInit + MinFinal.

arrivalTime(Flight, ArrivalTime) :-
    flight(Flight, _, _, DepartureTime, Duration, _),
    flightTime(DepartureTime, Duration, ArrivalTime).

%flight('TP1923', 'LPPR', 'LPPT', 1115, 55, 'TAP').
%airport('Aeroporto Francisco Sá Carneiro', 'LPPR', 'Portugal').
% TA MALLLLLL
countries(Company, [Country | ListOfCountries]) :-
    company(Company, _, _, _),
    flight(_, Origin, Destination, _, _, Company),
    (airport(_, Origin, Country) ; airport(_, Destination, Country)),
    countries(Company, ListOfCountries).

between30and90(Time1, Time2) :-
    Time1 < Time2,
    flightTime(Time1, 30, Test1),
    flightTime(Time1, 90, Test2),
    Time2 < Test2, Time2 > Test1.

%flight('TP1923', 'LPPR', 'LPPT', 1115, 55, 'TAP').
pairableFlights :-
    flight(F1, Go1, Reach1, _, _, _),
    flight(F2, Go2, Reach2, Departure2, _, _),
    (
        (
            Go1 == Reach2,
            F1 \= F2,
            arrivalTime(F1, ArrivalTime1),
            between30and90(ArrivalTime1, Departure2),
            write(Go1), write(' - '), write(F1), write('/'), write(F2)
        ) ; 
        (
            Reach1 == Go2,
            F1 \= F2,
            arrivalTime(F1, ArrivalTime1),
            between30and90(ArrivalTime1, Departure2),
            write(Reach1), write(' - '), write(F1), write('/'), write(F2), nl
        )
    ), fail.

%tripDays(Trip, Time, FlightTimes, Days).

% PERGUNTA 7
sumList([], 0).
sumList([H|T], Sum):-
    sumList(T, SumN),
    Sum is H + SumN.

avgFlightLengthFromAirport(Airport, AvgLength) :-
    findall(Duration, flight(_, Airport, _, _, Duration, _), L),
    sumList(L, Sum),
    length(L, NElems),
    AvgLength is Sum / NElems.

% PERGUNTA 8
numberOfCountries(Company, Number) :-
    findall(Country, (flight(_, Country, _, _, _, Company);
        flight(_, _, Country, _, _, Company)), To),
    sort(To, NoDuplicates),
    length(NoDuplicates, Number).

mostInternational(ListOfCompanies) :-
    findall(Company, flight(_, _, _, _, _, Company), CompanyList),
    findall(CompanyNumber, (
        flight(_, _, _, _, _, Company), numberOfCountries(CompanyNumber)
        ), CountriesTimes).



%   PERGUNTA 10
make_pairs(L, P, [X-Y|Zs]) :-
    select(X,L,L2),
    select(X,L2,L3),
    G =.. [P,X,Y],G,!,
    make_pairs(L3, P, Zs).
make_pairs([],_,[]).
    
