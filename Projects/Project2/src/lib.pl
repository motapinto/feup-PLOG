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

if_then_else(P, Q, R):- P, !, Q.
if_then_else(P, Q, R):- R.



hasLeftDot(Index, Vars, N) :-
	
	IndexN is Index - 1,
	
	IndexN >= 0,
	Col is IndexN mod N,
	Col >= 0,
	
	piece(Dot, '*'),
	nth0(IndexN, Vars, Elem),
	
	Elem #\ Dot #=> hasLeftDot(IndexN, Vars, N).
	


hasRightDot(Index, Vars, N) :-
	
	IndexN is Index + 1,

	LineNumber is Index // N,
	LastColumn is N * LineNumber + N - 1,
	IndexN =< LastColumn,

	piece(Dot, '*'),
	nth0(IndexN, Vars, Elem),

	Elem #\ Dot #=> hasRightDot(IndexN, Vars, N).


hasTopDot(Index, Vars, N) :-

	IndexN is Index - N,
	
	IndexN >= 0,
	
	piece(Dot, '*'),
	nth0(IndexN, Vars, Elem),
	
	Elem #\ Dot #=> hasTopDot(IndexN, Vars, N).

hasBottomDot(Index, Vars, N) :-
	
	IndexN is Index + N,
	
	Limit is N*N,
	IndexN =<  Limit,
	
	piece(Dot, '*'),
	nth0(IndexN, Vars, Elem),
	
	Elem #\ Dot #=> hasBottomDot(IndexN, Vars, N).

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