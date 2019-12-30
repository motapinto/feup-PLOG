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
        restrictSides(Matrix),
        restrictSides(TMatrix), !,
        N2 is N * 2,
        random(N, N2, NRandomPieces),
        PiecesNum #= NRandomPieces,
    % labeling of the one list matrix
    labeling([], OneListMatrix).
   % once(printBoard(Matrix, N)).


sumLetters([], 0).
sumLetters([H | T], TotalSum):-
	sumLetters(T, TotalSumAux),
    (H #> 0 #/\ H #< 4) #<=> B, 
    TotalSum #= TotalSumAux + B.

sumDots([], 0).
sumDots([H | T], TotalSum):-
	sumDots(T, TotalSumAux),
	H #= 4 #<=> B, 
    TotalSum #= TotalSumAux + B.

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
    
    sumLetters(H, NumberOfLetters),
    NumberOfLetters #=<1,

    sumDots(H, NumberOfDots),
    NumberOfDots #<= 1,
	
    restrictSides(T).


% Restricts a single line
restrictLine([], _).
restrictLine([H | T], DeltaDist):-  
DeltaDist #= 0 #<= H #= 2,
DeltaDist #\=0 #<= H #= 3,
solveLine(T).