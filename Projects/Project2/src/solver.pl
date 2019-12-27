:-use_module(library(lists)).
:-use_module(library(between)).
:-[board].
:-[lib].

main(Matrix, N) :-
    generate_board(N, Matrix),
    % Stores the matrix as 1 dimension
    append(Matrix, OneListMatrix),
    % Specifies the domain of the matrix
    domain(OneListMatrix, 0, 4), 
    % Stores the transposed of the matrix
    transpose(Matrix, TMatrix),
    % Restrictions for lines
    solveMatrix(Matrix),
    % Restrictions for columns
    solveMatrix(TMatrix),
    % labeling of the one list matrix
    labeling([], OneListMatrix),
    % prints the game Board
    once(printBoard(Matrix, N)).

solveMatrix([]).
solveMatrix([H|T]) :-
    %   Checks if there is 2 points or 1 letter horizontally and vertically
    automaton(H, [source(n1), sink(n6)], 
        [
            arc(n1, 0, n1),
            arc(n1, 4, n2),
            arc(n1, 1, n4),
            arc(n1, 2, n4),
            arc(n1, 3, n4),

            arc(n2, 0, n2),
            arc(n2, 4, n3),
            arc(n2, 1, n5),
            arc(n2, 2, n5),
            arc(n2, 3, n5),

            arc(n3, 0, n3),
            arc(n3, 1, n6),
            arc(n3, 2, n6),
            arc(n3, 3, n6),

            arc(n4, 0, n4),
            arc(n4, 4, n5),

            arc(n5, 0, n5),
            arc(n5, 4, n6),
    
            arc(n6, 0, n6)
        ]
    ),
    length(H, LineLength),
    solveLine(H, 0, LineLength),
    solveMatrix(T).

solveLine(Line, LineLength, LineLength).
solveLine(Line, Index, LineLength) :-
    nth0(Index, Line, IndexElem),
    piece(M, 'M'),
    piece(O, 'O'),
    piece(Dot, '*'),
    piece(Null, ' '),

    mpointAutomata(Line),

    NextIndex is Index + 1,
    solveLine(Line, NextIndex, LineLength).

% The automaton for the M point
mpointAutomata(Line) :-
    automaton(Line, _, Line, [source(s), sink(s3)],
        [
            arc(s, 0, s),
            arc(s, 4, s1),
            
            arc(s1, 0, s1, [C+1]),
            arc(s1, 2, s2),

            arc(s2, 0, s2, [C-1]),
            arc(s2, 4, s3),

            arc(s3, 0, s3)
        ],
        [C], [0], [N]
    ),
    N #= 0.
% The automaton fot the N point
npointAutomata(Line) :-
    automaton(Line, _, Line, [source(s), sink(s3)],
        [
            arc(s, 0, s),
            arc(s, 4, s1),
            
            arc(s1, 0, s1, [C+1]),
            arc(s1, 2, s2),

            arc(s2, 0, s2, [C-1]),
            arc(s2, 4, s3),

            arc(s3, 0, s3)
        ],
        [C], [0], [N]
    ),
    N #\ 0.
% The automaton fot the O point
opointAutomata(Line) :- 
    automaton(Line, [source(n1), sink(n4)], 
        [
            arc(n1, 0, n1),
            arc(n1, 1, n2),
            arc(n1, 4, n5),

            arc(n2, 0, n2),
            arc(n2, 4, n3),
            
            arc(n3, 0, n3),
            arc(n3, 4, n4),

            arc(n4, 0, n4),

            arc(n5, 0, n5),
            arc(n5, 4, n6),

            arc(n6, 1, n4),
            arc(n6, 0, n6)
        ]
    ).
