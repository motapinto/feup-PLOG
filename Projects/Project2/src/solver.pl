:-use_module(library(lists)).
:-use_module(library(between)).
:-use_module(library(system)).
:-[board].
:-[lib].
:-[puzzles].

solver(Matrix, N) :-
    % Resets time for statistics
    reset_timer,
    % Generates a board bazed on predefined boards
    generate_board(N, Selected, Matrix),
    once(printBoard(Selected, N)),
    sleep(2),
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
    !, labeling([], OneListMatrix),
    % prints the game Board
    once(printBoard(Matrix, N)),
    % prints elapsed time
    print_time.

% Solves received matrix (solves only the lines)
solveMatrix([]).
solveMatrix([H|T]) :-
    length(H, LineLength),
    %solveLine(H, 0, LineLength),
    dotDistance(H),
    solveMatrix(T).

% Restricts each line (2 dots and 1 letter per line + restricts line)
solveLine(_, LineLength, LineLength).
solveLine(Line, Index, LineLength) :-
    nth0(Index, Line, IndexElem),
    piece(M, 'M'),
    piece(N, 'N'),
    piece(O, 'O'),
    piece(Dot, '*'),
    piece(Null, ' '),

    allPointsAutomata(Line),

    NextIndex is Index + 1,
    solveLine(Line, NextIndex, LineLength).

% Automaton for M,N and O points
allPointsAutomata(Line) :-
    automaton(Line, _, Line, [source(s), sink(s3), sink(o2)],
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
        [C], [0], [N]
    ).


teste(List):-
    generate_board(5, Selected, List),
    append(List, OneList),
    domain(OneList, 0, 4),
    dotDistance(List),
    print(List),
    transpose(List, TList),
    dotDistance(TList),
    labeling([], OneList),
    printBoard(List, 5).



dotDistance([]).
dotDistance([H | T]):-

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

    piece(Dot, '*'),
    element(First, H, Dot),
    element(Last,  H, Dot),
    First #\= Last,
    piece(Mid, 'M'),
    FirstAux #= First - 1,
    LastAux #= Last - 1,
    iterateList(H, FirstAux, LastAux, 0, Int),
    dotDistance(T).
    

dotDistance1(H):-

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

    piece(Dot, '*'),
    nth0(First, H, Dot),
    reverse(H, ReversedList),
    nth0(LastAux, ReversedList, Dot),
    length(H, Int),
    Last is Int - LastAux - 1,
    piece(Mid, 'M'),
    iterateList(H, First, Last, 0, Int).
    


iterateList(_, _, _, Length, Length).
iterateList(List, IndexFirst, IndexLast, Counter, Lenght):-
    nth0(Counter, List, Elem),
    DistanceLeft is Counter - IndexFirst,
    DistanceRight is IndexLast - Counter,
    piece(O, 'O'),
    piece(Empty, ' '),
    piece(M, 'M'),
    piece(N, 'N'),

    (DistanceLeft #<0 #\/ DistanceRight #<0) #<=> Elem #= O,
    DistanceLeft #= DistanceRight #<=> Elem #= M,
    (DistanceRight #\= DistanceLeft #/\ DistanceLeft #>0 #/\ DistanceRight #>0) #<=> Elem #= N,

    NextCounter is Counter + 1,
    iterateList(List, IndexFirst, IndexLast, NextCounter, Lenght).




    

    
    

    