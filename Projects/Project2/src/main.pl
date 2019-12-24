:-use_module(library(clpfd)).
:-use_module(library(lists)).
:-[board].
:-[lib].

main(N, Vars):- 
    Vars = [A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, A22, A23, A24, A25], 
    % %reset_timer,
    % Limit is N*N,
    % length(Vars, Limit),
    domain(Vars,  0,  4),
    sumLines(Vars, N, 0), 
    sumColumns(Vars, N, 0),
    A2 #= A3 + 3,
    labeling([], Vars), 
    once(printBoard(Vars, N)).

sumLines(_, LineSize, LineSize).
sumLines(Vars, LineSize, Line):-
    sumLineDots(Vars, LineSize, 0, Line, TotalSumDots),
    TotalSumDots #= 2,
    sumLineLetters(Vars, LineSize, 0, Line, TotalSumLetters),
    TotalSumLetters #= 1,
    LineAux is Line + 1,
    sumLines(Vars, LineSize, LineAux).

sumLineDots(_, LineSize,  LineSize, _ , 0).
sumLineDots(Vars, LineSize, Counter, Line, TotalSum):-
    CounterAux is Counter + 1,
    sumLineDots(Vars, LineSize, CounterAux, Line, TotalSumAux),
    Index is LineSize * Line + Counter,
    checkingLetter(Vars, Index, LineSize),
    nth0(Index, Vars, Elem),
    Elem #= 4 #<=> B,
    TotalSum #= TotalSumAux + B.

sumLineLetters(_, LineSize,  LineSize, _ , 0).
sumLineLetters(Vars, LineSize, Counter, Line, TotalSum):-
    CounterAux is Counter + 1,
    sumLineLetters(Vars, LineSize, CounterAux, Line, TotalSumAux),
    Index is LineSize * Line + Counter,
    nth0(Index, Vars, Elem),

    (Elem #> 0 #/\  Elem #< 4) #<=> B,
    TotalSum #= TotalSumAux + B.

sumColumns(_, ColumnSize, ColumnSize).
sumColumns(Vars, ColumnSize, Column):-
    sumColumnDots(Vars, ColumnSize, 0, Column, TotalSumDots),
    TotalSumDots #= 2,
    sumColumnLetters(Vars, ColumnSize, 0, Column, TotalSumLetters),
    TotalSumLetters #= 1,
    ColumnAux is Column + 1,
    sumColumns(Vars, ColumnSize, ColumnAux).

sumColumnDots(_, ColumnSize,  ColumnSize, _ , 0).
sumColumnDots(Vars, ColumnSize, Counter, Column, TotalSum):-
    CounterAux is Counter + 1,
    sumColumnDots(Vars, ColumnSize, CounterAux, Column, TotalSumAux),
    Index is ColumnSize * Counter + Column,
    nth0(Index, Vars, Elem),
    Elem #= 4 #<=> B,
    TotalSum #= TotalSumAux + B.

sumColumnLetters(_, ColumnSize,  ColumnSize, _ , 0).
sumColumnLetters(Vars, ColumnSize, Counter, Column, TotalSum):-
    CounterAux is Counter + 1,
    sumColumnLetters(Vars, ColumnSize, CounterAux, Column, TotalSumAux),
    Index is ColumnSize * Counter + Column,
    nth0(Index, Vars, Elem),
    (Elem #> 0 #/\  Elem #< 4) #<=> B,
    TotalSum #= TotalSumAux + B.

% Vars  -> Board
% Index -> index of element
% N     -> Size of board (N*N)
checkingLetter(Vars, Index, N):-
    isMidpoint(Vars, Index, N).
    % isNpoint(Vars, Index, N),
    % isOpoint(Vars, Index, N).

% Vars  -> Board
% Index -> checks if index is midpoint
% N     -> Size of board (N*N)
isMidpoint(Vars, Index, N) :-
    checkLimits(Index, N) ->
        % Get's all 4 adjacent positions
        (
            RightPos is Index + 1,
            LeftPos is Index - 1, 
            UpPos is Index - N,
            DownPos is Index + N,
            % Get's all 4 adjacent elements
            nth0(RightPos, Vars, Right),
            nth0(LeftPos, Vars, Left),
            nth0(UpPos, Vars, Up),
            nth0(DownPos, Vars, Down),
            nth0(Index, Vars, Elem),

            hasTopDot(Index, Vars, N, Btop),
            hasBottomDot(Index, Vars, N, Bbottom),
            hasRightDot(Index, Vars, N, Bright),
            hasLeftDot(Index, Vars, N, Bleft),
            (Btop #= 1 #/\ Bbottom #= 1 #/\ Bright #= 1 #/\ Bleft #= 1) #<=> Elem #= Mid
        );
        ( 
            nth0(Index, Vars, Elem),
            (Elem #= 0 #\/ Elem #= 1 #\/ Elem #= 3 #\/ Elem #= 4) #<=> 1
        ).

% Vars  -> Board
% Index -> checks if index is midpoint
% N     -> Size of board (N*N)
isNpoint(Vars, Index, N) :-
    checkLimits(Index, N) ->
        (
            % Get's all 4 adjacent positions
            RightPos is Index + 1,
            LeftPos is Index - 1, 
            UpPos is Index - N,
            DownPos is Index + N,
            % Get's all 4 adjacent elements
            nth0(RightPos, Vars, Right),
            nth0(LeftPos, Vars, Left),
            nth0(UpPos, Vars, Up),
            nth0(DownPos, Vars, Down),
            nth0(Index, Vars, Elem),
            % Checks if all 4 are dots
            piece(Dot, '*'),
            piece(Mid, 'M'),
            (Left #= Dot #/\ Right #= Dot #/\ Up #= Dot #/\ Down #= Dot) #<=> Elem #= Mid
        );
        ( 
            nth0(Index, Vars, Elem),
            (Elem #= 0 #\/ Elem #= 1 #\/ Elem #= 2 #\/ Elem #= 4) #<=> 1
        ).

