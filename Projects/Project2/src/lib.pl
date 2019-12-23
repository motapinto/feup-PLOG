:-use_module(library(clpfd)).

reset_timer :- statistics(walltime, _).

print_time :-
	statistics(walltime,[_,T]),
	TS is ((T // 10) * 10) / 1000,
    nl, write('Solution Time: '), write(TS), write('s'), nl, nl.

clear:- 
    clear_console(100), !.

clear_console(0).
clear_console(N):-
	nl,
	N1 is N-1,
	clear_console(N1).

hasNoLeftDot(Index, Vars, N) :-
	% Left index cannot be a dot
	IndexN is Index - 1,
	piece(Dot, '*'),
	nth0(IndexN, Vars, Elem),
	Elem \= Dot,
	% Checks if has reached end of column
	Col is Index mod N,
	End is N - 1;
	Index == End -> true ; hasLeftDot(IndexN, Vars).

hasNoRightDot(Index, Vars) :-
	limitCol(Index, Vars),
	nth0(Index, Vars, Elem),
	IndexN is Index + 1,
	hasLeftDot(IndexN, Vars).

checkLimits(Index, N):-
	limitLine(Index, N),
	limitCol(Index, N).

limitCol(Index, N) :-
	% checking if index is on the first column
	FirstColumnn is Index mod N,
	FirstColumnn \= 0,
	% checking if index is on the last column
	LineNumber is Index // N,
	LastColumn is N * LineNumber + N - 1,
	Index \= LastColumn.

limitLine(Index, N) :-
	% checking if index on the first line
	Index >= N,
	% checking if index is on the last line
	Limit is N*N,
	Index <  Limit - N.