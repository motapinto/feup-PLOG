%participant(Id,Age,Performance)
participant(1234, 17, 'Pé coxinho').
participant(3423, 21, 'Programar com os pés').
participant(3788, 20, 'Sing a Bit').
participant(4865, 22, 'Pontes de esparguete').
participant(8937, 19, 'Pontes de pen-drives').
participant(2564, 20, 'Moodle hack').

%performance(Id,Times)
performance(1234,[120,120,120,120]).
performance(3423,[32,120,45,120]).
performance(3788,[110,2,6,43]).
performance(4865,[120,120,110,120]).
performance(8937,[97,101,105,110]).

hasPassed([]).
hasPassed([H|T]) :-
    (H == 120, !) ;
    hasPassed(T).

madeItThrough(Participant) :-
    performance(Participant, Times),
    hasPassed(Times).

getNElem(List, Pos, Elem) :-
    getNElem(List, Pos, Elem, 1).

getNElem([H|T], Counter, Elem, Counter) :- Elem = H.
getNElem([H|T], Pos, Elem, Counter) :-
    CounterN is Counter + 1,
    getNElem(T, Pos, Elem, CounterN).

juriTimes([], _, [], Total) :- Total is 0.
juriTimes([Participant | Others], Juri, [Elem | Times], Total) :-
    juriTimes(Others, Juri, Times, TotalN),
    performance(Participant, JuriTimes),
    getNElem(JuriTimes, Juri, Elem),
    Total is TotalN + Elem.

getListOfParticipants(In, Out) :-
    (
        performance(Id, _),
        \+member(Id, In),
        getListOfParticipants([Id | In], Out)
    ); Out = In.

isPatient([], Value) :- Value = 0.
isPatient([H|T], Value) :-
    isPatient(T, ValueN),
    (
        (H == 120, !, Value is ValueN + 1) ; 
        Value = ValueN
    ).

patientJuri(Juri) :-
    getListOfParticipants([], Out),
    juriTimes(Out, Juri, Times, _),
    isPatient(Times, Value), !,
    Value >= 2.

sumList([], Sum) :- Sum = 0.
sumList([H|T], Sum) :-
    sumList(T, ValueN),
    Sum is ValueN + H.

bestParticipant(P1, P2, P) :-
    performance(P1, T1),
    performance(P2, T2),
    sumList(T1, TT1),
    sumList(T2, TT2), !,
    (TT1 < TT2 -> P=P2 ; (TT1>TT2, P=P1)).

allPerfs :-
    (
        participant(ID, _, Move),
        performance(ID, Times),
        format('~d:~s:', [ID, Move]), write(Times), nl,
        fail
    ) ; true.

isSuccessful(Id) :-
    performance(Id, Times),
    length(Times, NJudges),
    sumList(Times, Sum),
    SumTarget is NJudges*120, !,
    Sum == SumTarget.

nSuccessfulParticipants(T) :-
    findall(Id, isSuccessful(Id), IdsList),
    length(IdsList, T).

juriesLikesId([], [], _).
juriesLikesId([120 | T], [Counter | Out], Counter):-
    CounterN is Counter + 1,
    juriesLikesId(T, Out, CounterN).
juriesLikesId([_ | T], Out, Counter):-
    CounterN is Counter + 1,
    juriesLikesId(T, Out, CounterN).

juriesLikesId(Times, LikesById) :-
    juriesLikesId(Times, LikesById, 1), !.

juriFans(JuriFansList) :-
    findall(Id - LikesById, (performance(Id, Times), juriesLikesId(Times, LikesById)), JuriFansList).