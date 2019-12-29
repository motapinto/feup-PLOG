:-use_module(library(clpfd)).
:-use_module(library(random)).
:-use_module(library(lists)).
:-use_module(library(between)).
:-[board].

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





	

restrictSides([], _).
restrictSides([H | T]):-
	
	automaton(H, _, H, [source(s), sink(s3), sink(o2)],
        [
            arc(s, 0, s),
            arc(s, 1, o3),
            arc(s, 4, s1),
            
            arc(s1, 0, s1, [C+1]),
            arc(s1, 2, s2),
            arc(s1, 3, s4),
            arc(s1, 4, o1),

            arc(s2, 0, s2, [C-1]),
            arc(s2, 4, s3),

            arc(o1, 0, o1),
            arc(o1, 1, o2),

            arc(o2, 0, o2),

            arc(o3, 0, o3),
            aarc(o3, 4, o4),

            arc(o4, 0, o4),
            arc(o4, 4, o2),

            arc(s3, 0, s3),

            arc(s4, 0, s4),
            arc(s4, 4, s3)
        ],
        [C], [0], [N]
    ),
	restrictSides(T).

sumPieces([], 0).
sumPieces([H | T], TotalSum):-
	sumPieces(T, TotalSumAux),
	H #\= 0 #<=> B, 
    TotalSum #= TotalSumAux + B.

generate_board1(N, Selected, Matrix):-
	length(Row, N),
	findall(Row, between(1, N, _), Matrix),
	transpose(Matrix, TMatrix),
	append(Matrix, OneListMatrix),
	length(OneListMatrix, Int),
	domain(OneListMatrix, 0, 4),
	NAux is N * 2,
	random(3, NAux, NPieces),
	
	% automaton(OneListMatrix, _, OneListMatrix, [source(n1), sink(n2)], [
	% 	arc(n1, 0, n1, [C + 1]),
	% 	arc(n1, 1, n1, [C + 1]),
	% 	arc(n1, 2, n1, [C + 1]),
	% 	arc(n1, 3, n1, [C + 1]),
	% 	arc(n1, 4, n1, [C + 1]),
	
	% 	% arc(n1, 0, n2, [C + 1]),
	% 	% arc(n1, 1, n2, [C + 1]),
	% 	% arc(n1, 2, n2, [C + 1]),
	% 	% arc(n1, 3, n2, [C + 1]),
	% 	% arc(n1, 4, n2, [C + 1]),
	% ])
	
	%nth1(Int, OneListMatrix, 2),

	
	restrictSides(Matrix),
	%restrictSides(TMatrix),
	% sumPieces(OneListMatrix, TotalNPieces),
	% TotalNPieces #= NPieces,

	labeling([], OneListMatrix),
    % prints the game Board
    once(printBoard(Matrix, N)).
	
