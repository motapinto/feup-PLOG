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