:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-use_module(library(between)).
:-[board].
:-[lib].

main(N, Board):- 
    %generate_board(N, Board),
    
    Board = [
        [A0, 4, A2, A3, A4], 
        [A5, A6, A7, A8, A9], 
        [4, A11, 4, A13, A14], 
        [A15, A16, A17, A18, A19], 
        [A20, 4, A22, A23, A24]
    ],
    % a passar tudo só para uma lista
    append(Board, OneListBoard),
    transpose(Board, TransposeBoard),

    % impor as restrições para a linhas e para as colunas
    % colunas e linhas só podem ter no máximo uma letra e dois pontos
    iterateListOfListsForDomain(Board),
    iterateListOfListsForDomain(TransposeBoard), 

    % faz todas as restrições do jogo
    Limit is N * N,
    restrictionsPos(OneListBoard , 0, Limit, N),

    % fazer o labeling de só uma lista
    labeling([], OneListBoard),
    
    % printMatrixes(Board, TransposeBoard, OneListBoard),

    % dar print do board, Atenção da print de uma lista de listas
    once(printBoard(Board, N)).

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




restrictionsPos(_, Limit, Limit, N).
restrictionsPos(OneListBoard, Index, Limit, N):-
    nth0(Index, OneListBoard, Elem),
    %restrictMidpoint(OneListBoard, Index, N, Elem),
    restrictOpoint(OneListBoard, Index, N),
    %restrictNpoint()
    IndexAux is Index + 1,
    restrictionsPos(OneListBoard, IndexAux, Limit, N).


% Vars  -> Board
% Index -> index of element
% N     -> Size of board (N*N)
checkingLetter(Vars, Index, N):-
    isOpoint(Vars, Index, N),
    isMidpoint(Vars, Index, N).
    % isOpoint(Vars, Index, N).


restrictOpoint(Vars, Index, N):-

    RightPos is Index + 1,
    LeftPos is Index - 1, 
    UpPos is Index - N,
    DownPos is Index + N,
    piece(LetterO, 'O'),
    Line is Index // N,
    LengthLeft is Index - Line * N,
    LengthTop = Line,
    LengthBottom is N - LengthTop - 1,
    LengthRight is N - LengthLeft - 1,
        
    write('a'),
    hasTopDot(UpPos, Vars, N, 0, LengthTop, DotSumTop),
    write('b'),
    hasBottomDot(DownPos, Vars, N, 0,  LengthBottom, DotSumBottom),
    write('c'),
    hasRightDot(RightPos, Vars, N,  0, LengthRight, DotSumRight),
    write('d'),
    hasLeftDot(LeftPos, Vars, N,  0, LengthLeft, DotSumLeft),
    nth0(Index, Vars, Elem), !,

    ((DotSumLeft #= 2 #\/ DotSumLeft #= 0) #/\ (DotSumBottom #= 0 #\/ DotSumBottom #= 2)) #<=> Elem #= LetterO.

% Vars  -> Board
% Index -> checks if index is midpoint
% N     -> Size of board (N*N)
% isMidpoint(Vars, Index, N) :-
%     checkLimits(Index, N) ->
%         % Get's all 4 adjacent positions
%         (
%             Line is Index // N,
%             LengthLeft is Index - Line * N + 1, 
%             LengthTop is Line + 1,
%             LengthBottom is N - LengthTop + 1,
%             LengthRight is N - LengthLeft + 1,


%             LengthHorizontal = [LengthLeft, LengthRight],
%             LengthVertical =  [LengthTop, LengthBottom],

%             minimum(MinHorizontal, LengthHorizontal),
%             minimum(MinVertical, LengthVertical),
%             checkMidPoint(Index, N, Vars, 1, MinHorizontal, MinVertical),
%             automaton(H, 
%             [source(n1), sink(n6)], 
%             [
%                 arc(n1, 0, n1),
%                 arc(n1, 4, n2),
%                 arc(n1, 1, n4),
%                 arc(n1, 2, n4),
%                 arc(n1, 3, n4),

%                 arc(n2, 0, n2),
%                 arc(n2, 4, n3),
%                 arc(n2, 1, n5),
%                 arc(n2, 2, n5),
%                 arc(n2, 3, n5),

%                 arc(n3, 0, n3),
%                 arc(n3, 1, n6),
%                 arc(n3, 2, n6),
%                 arc(n3, 3, n6),


%                 arc(n4, 0, n4),
%                 arc(n4, 4, n5),


%                 arc(n5, 0, n5),
%                 arc(n5, 4, n6),
            


%                 arc(n6, 0, n6)
%             ]
%         );
%         ( 
%             nth0(Index, Vars, Elem),
%             (Elem #= 0 #\/ Elem #= 1 #\/ Elem #= 3 #\/ Elem #= 4) #<=> 1
%         ).
       

