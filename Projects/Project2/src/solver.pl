:-[board].
:-[lib].
:-[generator].
:-[puzzles].

main(N, Matrix) :-
    % Generates a board bazed on predefined boards
    generate_board(N, Matrix),
    once(printBoard(Matrix, N)),
    % Solves the random puzzle
    solver(Matrix, N),
    % prints the game Board
    %once(printBoard(Matrix, N)).

solver(Matrix, N, Y) :-
    % Resets time for statistics
    reset_timer,
    % Stores the matrix as 1 dimension
    append(Matrix, OneListMatrix),
    % Specifies the domain of the matrix
    domain(OneListMatrix, 0, 4), 
    % Restrictions for lines
    solveMatrix(Matrix, N),
    % Restrictions for columns
    transpose(Matrix, TMatrix),
    solveMatrix(TMatrix, N), 
    % labeling of the one list matrix
<<<<<<< Updated upstream
    labeling([], OneListMatrix),
=======
    (Y == 1 ->  labeling([step, leftmost], OneListMatrix) ; true),
    (Y == 2 ->  labeling([step, min], OneListMatrix) ; true),
    (Y == 3 ->  labeling([step, max], OneListMatrix) ; true),
    (Y == 4 ->  labeling([step, first_fail], OneListMatrix) ; true),
    (Y == 5 ->  labeling([step, anti_first_fail], OneListMatrix) ; true),
    (Y == 6 ->  labeling([step, occurrence], OneListMatrix) ; true),
    (Y == 7 ->  labeling([step, most_constrained], OneListMatrix) ; true),
    (Y == 8 ->  labeling([step, max_regret], OneListMatrix) ; true),
>>>>>>> Stashed changes
    % prints elapsed time
    print_time.

% Solves received matrix (solves only the lines)
solveMatrix([], _).
solveMatrix([H|T], N) :-
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
            arc(s2, 0, s5),
            arc(s2, 4, s3),


            arc(o1, 0, o1),
            arc(o1, 1, o2),

            arc(o2, 0, o2),

            arc(o3, 0, o3),
            arc(o3, 4, o4),

            arc(o4, 0, o4),
            arc(o4, 4, o2),

            arc(s3, 0, s3),

            arc(s4, 0, s4, [C-1]),
            arc(s4, 4, s3)
        ],
        [C], [0], [DeltaDist]
    ),    
    Naux is N - 1,
    solveLine(H, DeltaDist, 0, Naux),
    solveMatrix(T, N).

% Restricts each line (2 dots and 1 letter per line + restricts line)
solveLine([], _, _, _).
solveLine([H | T], DeltaDist, Counter, Length):-  
    (
        (Counter \=0, Counter \= Length) ->
        fd_batch([DeltaDist #= 0 #<= H #= 2,DeltaDist #\=0 #<= H #= 3]); true
    ),
  
    CounterAux is Counter + 1,
    solveLine(T, DeltaDist, CounterAux, Length).