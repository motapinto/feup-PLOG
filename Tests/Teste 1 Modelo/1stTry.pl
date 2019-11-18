use_module(library(lists)).

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
performance(8937,[120,120,120,120]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PERGUNTA 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hasPassed([H|T]) :-
    (H == 120, !, true);
    hasPassed(T).
madeItThrough(Participant) :-
    performance(Participant, Times),
    hasPassed(Times).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PERGUNTA 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getElemN(_, [], _, _).
getElemN(N, [H|T], Counter, Elem) :-
    (Counter == N,  Elem = H);
    (
        CounterN is Counter+1,
        getElemN(N, T, CounterN, Elem)
    ).

juriTimes([], _, [], Total) :- Total = 0. 
juriTimes([Participant | Others], JuriMember, [JuriTime | Times], Total) :-
    juriTimes(Others, JuriMember, Times, TotalN),
    performance(Participant, ParticipantTime),
    getElemN(JuriMember, ParticipantTime, 1, JuriTime),
    Total is TotalN + JuriTime.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PERGUNTA 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getListOfParticipants(ParticipantsIn, ParticipantsOut) :-
    (
        performance(ParticipantID, _),
        \+member(ParticipantID, ParticipantsIn), !,
        getListOfParticipants([ParticipantID | ParticipantsIn], ParticipantsOut)
    );
    ParticipantsOut = ParticipantsIn.

hasNTimes120([], CounterIn, CounterOut) :- CounterOut = CounterIn.
hasNTimes120([H | T], CounterIn, CounterOut) :-
    (
        H == 120, CounterIn1 is CounterIn + 1, has2Times120(T, CounterIn1, CounterOut)
    );
    has2Times120(T, CounterIn, CounterOut).

patientJuri(JuriMember) :-
    getListOfParticipants([], List),
    juriTimes(List, JuriMember, Times, _), !,
    hasNTimes120(Times, 0, IsPatient), !, 
    IsPatient >= 2.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PERGUNTA 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sumList([], 0).
sumList([H|T], Sum) :-
    sumList(T, Rest),
    Sum is H + Rest.

bestParticipant(P1, P2, P) :-
    performance(P1, Times1),
    sumList(Times1, Total1),
    performance(P2, Times2),
    sumList(Times2, Total2),
    Total1 \= Total2,
    (
        (
            Total1 > Total2, !, P = P1
        ) ; 
        (
            P = P2    
        )    
            
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PERGUNTA 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
allPerfs :-
    (
        participant(ID, _, Move),
        performance(ID, Times),
        format('~d:~s:', [ID, Move]), write(Times), nl,
        fail
    ) ; true.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PERGUNTA 6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
perfectPerf([]).
perfectPerf([H|T]) :-
    H == 120, !, 
    perfectPerf(T).

successfulPerf(ParticipantID) :-
    performance(ParticipantID, Times),
    perfectPerf(Times).

nSuccessfulParticipants(T) :-
    findall(_, successfulPerf(_), PerfListIDs),
    length(PerfListIDs, T).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PERGUNTA 7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
juriFans(JuriFansList):-
    findall(Participant-JuriFans, (performance(Participant, Times), juriNotPressedList(Times, JuriFans)), JuriFansList).
  
juriNotPressedList(Times, JuriFans):- 
    addJuriToList(Times, 1, JuriFans), !.

addJuriToList([], _, []).
addJuriToList([120 | OtherTimes], Counter, [Counter | JuriFans]):-
    CounterNext is Counter + 1,
    addJuriToList(OtherTimes, CounterNext, JuriFans).
addJuriToList([_ | OtherTimes], Counter, JuriFans):-
    CounterNext is Counter + 1,
    addJuriToList(OtherTimes, CounterNext, JuriFans).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PERGUNTA 8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eligibleOutcome(Id,Perf,TT) :-
    performance(Id,Times),
    madeItThrough(Id),
    participant(Id,_,Perf),
    sumList(Times,TT).

nBestList(NBest, Finished, TTListIn, TTListOut) :-
    length(TTListIn, Size),
    (
        (
            Size > NBest , 
            min_member(TTListIn, Min),
            delete(TTListIn, Min, TTListIn2),
            nBestList(NBest, Finished, TTListIn2, TTListOut), !
        )
        ; 
        (
            Finished = 1, !, TTListOut = TTListIn
        )
    ).

nextPhase(N, P):-
    findall(TT, eligibleOutcome(_, _, TT), TTList),
    findall(
        TT-Id-Perf, 
        (
            nBestList(N, _, TTList, _, TTFinal), 
            member(TT, TTFinal),
            eligibleOutcome(Id, Perf, TT)
        ), 
        P
    ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PERGUNTA 9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
predX(Q, [ID|IDs], [Mode|Modes]) :-
    participant(ID, Age, Mode), Age=<Q, !,
    predX(Q, IDs, Modes).
predX(Q, [ID|IDs], _) :-
    participant(ID, Age, _), Age>Q,
    predX(Q, IDs, _).
predX(_,[],[]).

%Representando Q uma idade,
%Unifica na lista [P|Ps] uma lista de performance 
%em que os candidatos têm idade menor ou igual a Q

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PERGUNTA 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
impoe(X,L) :-
    length(Mid,X),
    append(L1,[X|_],L), append(_,[X|Mid],L1).

% Este predicado retorna true se para k=X existe uma sub-sequencia 
% começada e terminada com o numero k e com k outros numeros pelo meio.
% Retorna os K possiveis para o problema acima descrito

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   PERGUNTA 11
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

langford(N, L):- 
    getLangFord(N, L).
langford(N, L):- 
    getLangFord(N, List),
    reverse(List, L).

getLangFord(N, L):-
    once(impoe(N, L)),
    Size is N * 2,
    length(L, Size),
    NextN is N - 1,
    forimpoe(NextN, L), !.

forimpoe(0,_L).
forimpoe(Iter,L):-
    Iter > 0,
    impoe(Iter, L),
    NextIter is Iter - 1,
    forimpoe(NextIter, L), !.

