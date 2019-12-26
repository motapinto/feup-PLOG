:-use_module(library(lists)).
:-use_module(library(between)).
:-[board].
:-[lib].

generate_board(N, Board) :-
    length(Row, N),
    findall(Row, between(1, N, _), Board).


printMatrixes(Board, TransposeBoard, OneListBoard):-
    print('Board normal -->'), nl,
    print(Board),
    print('Board transposto -->'), nl,
    print(TransposeBoard), nl,
    print('Board one List -->'), nl,
    print(OneListBoard), nl.


main(N, Board):- 

    generate_board(N, Board),
    % Board = [
    %     [A0, A1, A2, A3, A4], 
    %     [A5, A6, A7, A8, A9], 
    %     [A10, A11, A12, A13, A14], 
    %     [A15, A16, A17, A18, A19], 
    %     [A20, A21, A22, A23, A24]
    % ],
    % a passar tudo só para uma lista
    append(Board, OneListBoard),
    transpose(Board, TransposeBoard),

    % impor as restrições para a linhas e para as colunas
    % colunas e linhas só podem ter no máximo uma letra e dois pontos
    iterateListOfListsForDomain(Board),
    iterateListOfListsForDomain(TransposeBoard), 

    % restringe, nas bordas do board só pode estar a letra O ou um ponto
    Limit is N * N,
    restrictionsPos(OneListBoard , Board, TransposeBoard, 0, Limit, N),

    %tentar fazer as restirçoes mid, O, N
   

    % fazer o labeling de só uma lista
    labeling([], OneListBoard),
    
    printMatrixes(Board, TransposeBoard, OneListBoard),

    % dar print do board, Atenção da print de uma lista de listas
    once(printBoard(Board, N)).

restrictionsPos(_, _, _, Limit, Limit, _).
restrictionsPos(OneListBoard, Board, TransposeBoard, Index, Limit, N):-
    nth0(Index, OneListBoard, Elem),
    
    restrictOpoint(Board, TransposeBoard, Index, N, Elem),
    % restrictNpoint(Board, TransposeBoard, Index, N, Elem),
    restrictMpoint(Board, TransposeBoard, Index, N, Elem),
    
    IndexAux is Index + 1,
    restrictionsPos(OneListBoard,  Board, TransposeBoard, IndexAux, Limit, N).

iterateListOfListsForDomain([]).
iterateListOfListsForDomain([H | T]):-
    domain(H, 0, 4), 
    automaton(H, 
        [source(n1), sink(n6)], 
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


% All restrictions aplied to M point
restrictMpoint(Board, TransposeBoard, Index, N, Elem):-
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
    
    piece(LetterM, 'M'),
    (LineRightCounterDots #= 1 #/\ LineLeftCounterDots #= 1 #/\ ColumnTopCounterDots #= 1 #/\ ColumnBottomCounterDots #= 1) #<=> Elem #= LetterM.

% All restrictions aplied to N point
restrictNpoint(Board, TransposeBoard, Index, N, Elem):-
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

% All restrictions aplied to O point
restrictOpoint(Board, TransposeBoard, Index, N, Elem):-
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