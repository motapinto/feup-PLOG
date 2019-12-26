:-use_module(library(clpfd)).

reset_timer :- 
	statistics(walltime, _).

print_time :-
	statistics(walltime,[_,T]),
	TS is ((T // 10) * 10) / 1000,
    nl, write('Solution Time: '), write(TS), write('s'), nl, nl.

clear :-
    clear_console(100), !.

clear_console(0).
clear_console(N) :-
	nl,
	N1 is N-1,
	clear_console(N1).

countingNumberDots(List, N) :-
    automaton(List, _, List,
    [source(s), sink(s)],
    [
        arc(s,0,s),
        arc(s,1,s),
        arc(s,2,s),
        arc(s,3,s),  
		arc(s,4,s,[C+1])
	],
    [C],[0],[N]).

getSublist(_, [], _, Length, Length).
getSublist(List,[H | T], Start, CounterLenght, Length) :-
    Index is Start +  CounterLenght,
    CounterLenghtAux is CounterLenght + 1,
    sublistOur(List, T, Start, CounterLenghtAux, Length),
    nth0(Index, List, Elem),
    H = Elem.	