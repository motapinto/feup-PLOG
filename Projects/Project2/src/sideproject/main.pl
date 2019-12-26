:-use_module(library(lists)).
:-use_module(library(between)).
:-[board].
:-[lib].

main(N, Board):- 
    %generate_board(N, Board),
    Board = [
        [A0, 4, A2, A3, A4, AASD], 
        [AFGF, A6, SDF, A8, A9, AS], 
        [4, VDBT, 4, A13, A14, DF], 
        [A15, A16, A17, A18, A19, DF], 
        [A20, 4, A22, A23, A24, FG],
        [ASDFG, Q3SA, CXVEF, CBV, XV, XB]
    ],

    % Stores the one list board and the transpose board
    append(Board, OneListBoard),
    transpose(Board, TransposeBoard),

    % domain and minor restrictions -> vertically and horizontally 2 dots and 1 letter
    iterateListOfListsForDomain(Board),
    iterateListOfListsForDomain(TransposeBoard), 

    % restrictions for M,N and O points
    Limit is N * N,
    restrictionsPos(OneListBoard , Board, TransposeBoard, 0, Limit, N), !,

    % labeling of the one list board
    labeling([], OneListBoard),
    
    % prints the game Board
    once(printBoard(Board, N)).

%   Restricts all indexes of the board based on the rules of the game
restrictionsPos(_, _, _, Limit, Limit, _).
restrictionsPos(OneListBoard, Board, TransposeBoard, Index, Limit, N) :-
    nth0(Index, OneListBoard, Elem),
    
    % restrictOpoint(Board, TransposeBoard, Index, N, Elem),
    % restrictNpoint(Board, TransposeBoard, Index, N, Elem),
    restrictMpoint(OneListBoard, Index, N),
    
    IndexAux is Index + 1,
    restrictionsPos(OneListBoard,  Board, TransposeBoard, IndexAux, Limit, N).

%   Checks if there is 2 points or 1 letter horizontally and vertically
iterateListOfListsForDomain([]).
iterateListOfListsForDomain([H|T]):-
    domain(H, 0, 4), 
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
    
    iterateListOfListsForDomain(T).


%   All restrictions aplied to M point
restrictMpoint(Vars, Index, N) :-
    checkLimits(Index, N) ->
        % Get's all 4 adjacent positions
        (
            Line is Index // N,
            LengthLeft is Index - Line * N + 1, 
            LengthTop is Line + 1,
            LengthBottom is N - LengthTop + 1,
            LengthRight is N - LengthLeft + 1,

            LengthHorizontal = [LengthLeft, LengthRight],
            LengthVertical =  [LengthTop, LengthBottom],

            minimum(MinHorizontal, LengthHorizontal),
            minimum(MinVertical, LengthVertical),
            checkMidPoint(Index, N, Vars, 1, MinHorizontal, MinVertical)
        );
        ( 
            nth0(Index, Vars, Elem),
            (Elem #= 0 #\/ Elem #= 1 #\/ Elem #= 3 #\/ Elem #= 4) #<=> 1
        ).

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
	iterateColumnMidPoint(Index, IndexLeft, IndexRight, N, Vars, 1, VerticalLenght, Restrictions),
	CounterHorizontalAux is CounterHorizontal+ 1,
	checkMidPoint(Index, N, Vars, CounterHorizontalAux, HorizontalLenght, VerticalLenght).


iterateColumnMidPoint(_, _, _, _, _, VerticalLenght, VerticalLenght, _).
iterateColumnMidPoint(Index, IndexLeft, IndexRight, N, Vars, CounterVertical, VerticalLenght, [H|T]):-

	IndexTop is Index - N * CounterVertical,
	IndexBottom is Index + N * CounterVertical,

	nth0(IndexLeft, Vars, Left),
	nth0(IndexRight, Vars, Right),
	nth0(IndexTop, Vars, Top),
	nth0(IndexBottom, Vars, Bottom),
	nth0(Index, Vars, Elem),
	piece(Dot, '*'),
	piece(Mid, 'M'),
    (Top #= Dot #/\ Bottom #= Dot #/\ Right #= Dot #/\ Left #= Dot) #<=> Elem #= Mid,
    
    ListAux = [Top, Bottom, Right, Left],
    H = ListAux, 

	CounterVerticalAux is CounterVertical + 1,
	iterateColumnMidPoint(Index, IndexLeft, IndexRight, N, Vars, CounterVerticalAux, VerticalLenght, T).

%   All restrictions aplied to N point
restrictNpoint(Board, TransposeBoard, Index, N, Elem) :-
    Line is Index // N,
    Column is Index - Line * N,
    ColumnNext is Column + 1,
    LineNext is Line + 1,
    nth0(Line, Board, LineList),
    nth0(Column, TransposeBoard, ColumnList),
    
    LengthLeft is Index - Line * N, 
    LengthTop is Line,
    LengthBottom is N - LengthTop - 1,
    LengthRight is N - LengthLeft - 1,

    getSublist(LineList, LineListLeft, 0, 0, LengthLeft),
    getSublist(LineList, LineListRight, ColumnNext, 0, LengthRight),
    getSublist(ColumnList, ColumnListTop, 0, 0, LengthTop),
    getSublist(ColumnList, ColumnListBottom, LineNext, 0, LengthBottom),
    
    countingNumberDots(LineListLeft, LineLeftCounterDots),
    countingNumberDots(LineListRight, LineRightCounterDots),
    countingNumberDots(ColumnListTop, ColumnTopCounterDots),
    countingNumberDots(ColumnListBottom, ColumnBottomCounterDots),
    
    piece(LetterN, 'N'),
    (LineRightCounterDots #= 1 #/\ LineLeftCounterDots #= 1 #/\ ColumnTopCounterDots #= 1 #/\ ColumnBottomCounterDots #= 1) #<=> Elem #= LetterN.

%   All restrictions aplied to O point
restrictOpoint(Board, TransposeBoard, Index, N, Elem) :-
    Line is Index // N,
    Column is Index - Line * N,
    ColumnNext is Column + 1,
    LineNext is Line + 1,
    nth0(Line, Board, LineList),
    nth0(Column, TransposeBoard, ColumnList),
    
    LengthLeft is Index - Line * N, 
    LengthTop is Line,
    LengthBottom is N - LengthTop - 1,
    LengthRight is N - LengthLeft - 1,

    getSublist(LineList, LineListLeft, 0, 0, LengthLeft),
    getSublist(LineList, LineListRight, ColumnNext, 0, LengthRight),
    getSublist(ColumnList, ColumnListTop, 0, 0, LengthTop),
    getSublist(ColumnList, ColumnListBottom, LineNext, 0, LengthBottom),
    
    countingNumberDots(LineListLeft, LineLeftCounterDots),
    countingNumberDots(LineListRight, LineRightCounterDots),
    countingNumberDots(ColumnListTop, ColumnTopCounterDots),
    countingNumberDots(ColumnListBottom, ColumnBottomCounterDots),
    
    piece(LetterO, 'O'),
    ((LineRightCounterDots #= 2 #\/ LineLeftCounterDots #= 2) #/\ (ColumnTopCounterDots #= 2 #\/ ColumnBottomCounterDots #= 2)) #<=> Elem #= LetterO.