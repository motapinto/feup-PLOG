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

generate_board(N, Board) :-
    length(Row, N),
    findall(Row, between(1, N, _), Board).

hasLeftDot(Index, Vars, N, Lenght, Lenght, 0).
hasLeftDot(Index, Vars, N, Counter, Lenght, DotSum) :-

	ConterAux is Counter + 1,
	hasLeftDot(Index, Vars, N, CounterAux, Lenght, DotSumAux),
	
	IndexN is Index - Counter,
	nth0(IndexN, Vars, Elem),
	piece(Dot, '*'),
	Elem #= Dot #<=> B,
	DotSum #= DotSumAux + B.

hasRightDot(Index, Vars, N, Lenght, Lenght, 0).
hasRightDot(Index, Vars, N, Counter, Lenght, DotSum) :-

	ConterAux is Counter + 1,
	hasRightDot(Index, Vars, N, CounterAux, Lenght, DotSumAux),
	
	IndexN is Index + Counter,
	nth0(IndexN, Vars, Elem),
	piece(Dot, '*'),
	Elem #= Dot #<=> B,
	DotSum #= DotSumAux + B.	
	

hasTopDot(Index, Vars, N, Lenght, Lenght, 0).
hasTopDot(Index, Vars, N, Counter, Lenght, DotSum) :-

	ConterAux is Counter + 1,
	hasTopDot(Index, Vars, N, CounterAux, Lenght, DotSumAux),
	
	IndexN is Index - N * Counter,
	piece(Dot, '*'),
	nth0(IndexN, Vars, Elem),
	Elem #= Dot #<=> B,
	DotSum #= DotSumAux + B.


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



checkMidPoint(Index, N, Vars, HorizontalLenght, HorizontalLenght, VerticalLenght).
checkMidPoint(Index, N, Vars, CounterHorizontal, HorizontalLenght, VerticalLenght):-

	IndexLeft is Index - CounterHorizontal,
	IndexRight is Index + CounterHorizontal,
	iterateColumnMidPoint(Index, IndexLeft, IndexRight, N, Vars, 1, VerticalLenght),
	CounterHorizontalAux is CounterHorizontal+ 1,
	checkMidPoint(Index, N, Vars, CounterHorizontalAux, HorizontalLenght, VerticalLenght).

iterateColumnMidPoint(Index, IndexLeft, IndexRight, N, Vars, VerticalLenght, VerticalLenght).
iterateColumnMidPoint(Index, IndexLeft, IndexRight, N, Vars, CounterVertical, VerticalLenght):-

	IndexTop is Index - N * CounterVertical,
	IndexBottom is Index + N * CounterVertical,

	nth0(IndexLeft, Vars, Left),
	nth0(IndexRight, Vars, Right),
	nth0(IndexTop, Vars, Top),
	nth0(IndexBottom, Vars, Bottom),
	nth0(Index, Vars, Elem),
	piece(Dot, '*'),
	piece(Mid, 'M'),
	(Top #= Dot #/\ Bottom #= Dot #/\ Right #= Dot #/\ Left #= Dot) #=> Elem #= Mid,
	CounterVerticalAux is CounterVertical + 1,
	iterateColumnMidPoint(Index, IndexLeft, IndexRight, N, Vars, CounterVerticalAux, VerticalLenght).


	
printMatrixes(Board, TransposeBoard, OneListBoard):-
    print('Board normal -->'), nl,
    print(Board),
    print('Board transposto -->'), nl,
    print(TransposeBoard), nl,
    print('Board one List -->'), nl,
    print(OneListBoard), nl.

	
	


	