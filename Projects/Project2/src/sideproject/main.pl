:-use_module(library(clpfd)).
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

    %generate_board(N, Board),
    
    Board = [
        [A0, A1, A2, A3, A4], 
        [A5, A6, A7, A8, A9], 
        [A10, A11, A12, A13, A14], 
        [A15, A16, A17, A18, A19], 
        [A20, A21, A22, A23, A24]
    ],
    % a passar tudo só para uma lista
    append(Board, OneListBoard),
    transpose(Board, TransposeBoard),
    
    printMatrixes(Board, TransposeBoard, OneListBoard),

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

restrictionsPos(_, _, _, Limit, Limit, N).
restrictionsPos(OneListBoard, Board, TransposeBoard, Index, Limit, N):-
    nth0(Index, OneListBoard, Elem),
    %restrictMidpoint(OneListBoard, Index, N, Elem),
    %restrictOpoint(Board, TransposeBoard, Index, N, Elem),
    restrictOpoint(OneListBoard, Index, N),
    %restrictNpoint()
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

% Vars  -> Board
% Index -> index of element
% N     -> Size of board (N*N)
checkingLetter(Vars, Index, N):-
    isOpoint(Vars, Index, N),
    isMidpoint(Vars, Index, N).
    % isOpoint(Vars, Index, N).

countingNumberDots(List, N):-
    automaton(List, _, List,
    [source(s), sink(s)],
    [
        arc(s,0,s),
        arc(s,1,s),
        arc(s,2,s),
        arc(s,3,s),  
        arc(s,4,s,[C+1])
    ],
    [C],[0],[N]).



% Para efeitos de teste
% restrictOpoint(Board,  Index, N):-

%     transpose(Board, TransposeBoard),


restrictOpoint(Board, TransposeBoard, Index, N, Elem):-
    
    Line is Index // N,
    Column is Index - Line * N,
    nth0(Line, Board, LineList),
    nth0(Column, TransposeBoard, ColumnList),
    
    LengthLeft is Index - Line * N + 1, 
    LengthTop is Line + 1,
    LengthBottom is N - LengthTop + 1,
    LengthRight is N - LengthLeft + 1,
    
    sublistOur(LineList, LineListLeft, 0, 0,),
    sublistOur(LineList, LineListRight, ColumnAux, 0, ),
    sublistOur(ColumnList, ColumnListTop, 0, 0, Line),
    sublistOur(ColumnList, ColumnListBottom, LineAux, N),

    
    countingNumberDots(LineListLeft, LineLeftCounterDots),
    countingNumberDots(LineListRight, LineRightCounterDots),
    countingNumberDots(ColumnListTop, ColumnTopCounterDots),
    countingNumberDots(ColumnListBottom, ColumnBottomCounterDots).

    print(LineLeftCounterDots),
    print(LineRightCounterDots),
    print(ColumnTopCounterDots),
    print(ColumnBottomCounterDots).
    
    piece(LetterO, 'O'),
    ((LineLeftCounterDots #= 0 #\/ LineRightCounterDots #= 0) #/\ (ColumnTopCounterDots #= 0 #\/ ColumnBottomCounterDots #= 0)) #<=> Elem #= LetterO.



sublistOur(List, [], Start, Length, Length).
sublistOur(List,[H | T], Start, CounterLenght, Length):-
    Index is Start +  CounterLenght,
    CounterLenghtAux is CounterLenght + 1,
    sublistOur(List, T, Start, CounterLenghtAux, Length),
    nth0(Index, List, Elem),
    H = Elem.









% Vars  -> Board
% Index -> checks if index is midpoint
% N     -> Size of board (N*N)
isMidpoint(Vars, Index, N) :-
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
       

