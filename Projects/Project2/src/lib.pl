:-use_module(library(clpfd)).

reset_timer :- statistics(walltime, _).

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

if_then_else(P, Q, R) :- P, !, Q.
if_then_else(P, Q, R) :- R.


hasLeftDot(Index, Vars, N, Lenght, Lenght, 0).
hasLeftDot(Index, Vars, N, Counter, Lenght, DotSum) :-

	ConterAux is Counter + 1,
	hasLeftDot(Index, Vars, N, CounterAux, Lenght, DotSumAux),
	
	IndexN is Index - Counter,

	IndexN is Index + N * Counter,
	nth0(IndexN, Vars, Elem),
	piece(Dot, '*'),
	Elem #= Dot #<=> B,
	DotSum #= DotSumAux + B.

hasRightDot(Index, Vars, N, Lenght, Lenght, 0).
hasRightDot(Index, Vars, N, Counter, Lenght, DotSum) :-

	ConterAux is Counter + 1,
	hasRightDot(Index, Vars, N, CounterAux, Lenght, DotSumAux),
	
	IndexN is Index + Counter,

	IndexN is Index + N * Counter,
	nth0(IndexN, Vars, Elem),
	piece(Dot, '*'),
	Elem #= Dot #<=> B,
	DotSum #= DotSumAux + B.	
	

hasTopDot(Index, Vars, N, Lenght, Lenght, 0, -1).
hasTopDot(Index, Vars, N, Counter, Lenght, DotSum, Pos) :-

	ConterAux is Counter + 1,
	hasTopDot(Index, Vars, N, CounterAux, Lenght, DotSumAux, PosAux),
	
	IndexN is Index - N * Counter,
	nth0(IndexN, Vars, Elem),
	piece(Dot, '*'),
	Elem #= Dot #<=> B,
	DotSum #= DotSumAux + B, 
	PosAux #= -1 #=> 
		(
			B #= 1 #=> Pos #= Index,
			B #= 0 #=> Pos #= PosAux 
		)


hasBottomDot(Index, Vars, N, Lenght, Lenght, 0).
hasBottomDot(Index, Vars, N, Counter, Lenght, DotSum) :-

	ConterAux is Counter + 1,
	hasBottomDot(Index, Vars, N, CounterAux, Lenght, DotSumAux),
	
	IndexN is Index + N * Counter,
	nth0(IndexN, Vars, Elem),
	piece(Dot, '*'),
	Elem #= Dot #<=> B,
	DotSum #= DotSumAux + B.	
	
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