:-use_module(library(lists)).
:-use_module(library(between)).
:-[board].
:-[lib].

main(Matrix, N) :-
    % generate_board()
    Matrix = [
        [A0, 4, A2, A3, A4, AASD], 
        [AFGF, A6, SDF, A8, A9, AS], 
        [4, VDBT, 4, A13, A14, DF], 
        [A15, A16, A17, A18, A19, DF], 
        [A20, 4, A22, A23, A24, FG],
        [ASDFG, Q3SA, CXVEF, CBV, XV, XB]
    ],

    % Stores the matrix as 1 dimension
    append(Matrix, OneListMatrix),
    % Specifies the domain of the matrix
    domain(OneListMatrix, 0, 4), 
    % Restrictions for lines
    solveMatrix(Matrix),
    % Restrictions for columns
    transpose(Matrix, TMatrix),
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
solveLine(Line, ElemIndex, LineLength) :-
    restrictionsMpoint(ElemIndex, Line, LineLength),
    % restrictionsNpoint(Line, ElemIndex, LineLength),
    % restrictionsOpoint(Line, ElemIndex, LineLength),

    % Next iteration of the line to be solved
    NextIndex is ElemIndex + 1,
    solveLine(Line, NextIndex, LineLength).

%1º)posto a esqerda e ponto direita
%2º)igual distancia
restrictionsMpoint(Index, Line, LineLength) :-

    LengthLeft is Index,
    LengthRight is LineLength - Index - 1,
    LengthHorizontal = [LengthLeft, LengthRight],

    minimum(MinHorizontal, LengthHorizontal),
    checkMPoint(Index, IndexElem, Line, LineLength, 1, MinHorizontal).

checkMPoint(_, _, _, _, N, N).
checkMPoint(Index, IndexElem, Line, LineLength, ElemCounter, NumberIterations):-
    LastIndex is LineLength - 1,
    (Index > 0 , Index < LastIndex) ->
    (
        IndexLeft is Index - ElemCounter,
        IndexRight is Index + ElemCounter,
        nth0(IndexLeft, Line, Left),
        nth0(IndexRight, Line, Right),
        piece(Dot, '*'),
        piece(M, '*'),
        (Left #= Dot #/\ Right #= Dot) #=> IndexElem #= M,

        ElemCounterNext is ElemCounter + 1,
        checkMPoint(Index, IndexElem, Line, LineLength, ElemCounterNext, NumberIterations)
    );
    (
        piece(O, 'O'),
        piece(Dot, '*'),
        piece(Null, ' '),
        IndexElem #= O #\/ IndexElem #= Dot #\/ IndexElem #= Null
    ).