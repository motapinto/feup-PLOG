generate_board1(N, Matrix):-
    % limits generated board length
	length(Row, N),
    findall(Row, between(1, N, _), Matrix),
    % Stores the matrix as 1 dimension
	transpose(Matrix, TMatrix),
	append(Matrix, OneListMatrix),
	% Specifies the domain of the matrix
    domain(OneListMatrix, 0, 4),
    % Number of pieces generated between N and 2*N
	N2 is N * 2,
	random(N, N2, NRandomPieces),
    % Counts the number of pieces generated
    automaton(OneListMatrix, _, OneListMatrix, [source(s), sink(s)],
        [
            arc(s, 0, s),
            arc(s, 1, s, [C + 1]),
            arc(s, 2, s, [C + 1]),
            arc(s, 3, s, [C + 1]),
            arc(s, 4, s, [C + 1])
        ],
        [C], [0], [PiecesNum]
    ),  
    % Restricts number of pices generated and restricts them based on game rules
    PiecesNum #= NRandomPieces,
	restrictSides(Matrix),
	restrictSides(TMatrix),
    % labeling of the one list matrix
    !, labeling([], OneListMatrix),
    % prints the game Board
	once(printBoard(Matrix, N)).

restrictSides([]).
restrictSides([H | T]):-
	automaton(H, _, H, [source(s), sink(s), sink(s1), sink(s2), sink(s3), sink(s4), sink(o1), sink(o2), sink(o3), sink(o4)],
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
            arc(o3, 4, o4),

            arc(o4, 0, o4),
            arc(o4, 4, o2),

            arc(s3, 0, s3),

            arc(s4, 0, s4, [C-1]),
            arc(s4, 4, s3)
        ],
        [C], [0], [DeltaDist]
    ),
    restrictLine([], DeltaDist),
	restrictSides(T).

% Restricts a single line
restrictLine([], _).
restrictLine([H | T], DeltaDist):-  
    DeltaDist #= 0 #<= H #= 2,
    DeltaDist #\=0 #<= H #= 3,
    solveLine(T).