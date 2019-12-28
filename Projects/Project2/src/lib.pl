:-use_module(library(clpfd)).
:-use_module(library(random)).

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

generate_board(N, Selected, Matrix) :-
	N > 4,
	N == 5 -> (random(0, 11, Puzzle), choosePuzzle(Puzzle, Selected), choosePuzzle(Puzzle, Matrix)) ; true,
	N == 6 -> (random(12, 21, Puzzle), choosePuzzle(Puzzle, Selected), choosePuzzle(Puzzle, Matrix)); true,
	N == 7 -> (random(21, 25, Puzzle), choosePuzzle(Puzzle, Selected), choosePuzzle(Puzzle, Matrix)); true,
	N > 7 -> (
			length(Row, N),
			findall(Row, between(1, N, _), Selected),
			findall(Row, between(1, N, _), Matrix)
		) ; fail.