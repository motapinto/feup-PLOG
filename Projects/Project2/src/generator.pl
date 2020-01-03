

generate_board1(N, Matrix):-
    % limits generated board length
	length(Row, N),
    findall(Row, between(1, N, _), MatrixAux),
    % Stores the matrixAux as 1 dimension
	transpose(MatrixAux, TMatrix),
	append(MatrixAux, OneListMatrix),
	% Specifies the domain of the matrixAux
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
        restrictLine(MatrixAux, N),
        restrictLine(TMatrix, N), !,
        N2 is N * 2,
        random(N, N2, NRandomPieces),
        PiecesNum #= 5,
        print(NRandomPieces), nl,
    % labeling of the one list matrixAux
    write('aaaaaa'),
    nl,
    labeling([], OneListMatrix),
    write('bbbbbb'),
    nl,
    length(Row, N),
    once(findall(Row, between(1, N, _), Matrix)),
    append(Matrix, OneListMatrix1),
    once(iterateThroughTwoMatrix(OneListMatrix1, OneListMatrix)),
    once(printBoard(Matrix, N)).

selRandom(ListOfVars, Var, Rest):-
    random_select(Var, ListOfVars, Rest). 

iterateThroughTwoMatrix(_,[]).
iterateThroughTwoMatrix([H | T],[H1 | T1]):-
    (
        H1 \= 0 -> H = H1; true
    ),
    iterateThroughTwoMatrix(T, T1).




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

restrictLine([], _).
restrictLine([H | T], N):-
    Naux is N - 1,
    nth0(0, H, First),
    nth0(Naux, H, Last),

    First #\= 2 #/\ First #\= 3 #/\Last #\= 2 #/\ Last #\= 3,

    sumLetters(H, NumberOfLetters),
    NumberOfLetters #=<1,

    sumDots(H, NumberOfDots),
    NumberOfDots #<= 1,
	
    restrictLine(T, N).


% % Restricts a single line
% restrictLine([], _).
% restrictLine([H | T], DeltaDist):-  
% DeltaDist #= 0 #<= H #= 2,
% DeltaDist #\=0 #<= H #= 3,
% solveLine(T).
