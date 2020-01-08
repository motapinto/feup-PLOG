:- use_module(library(lists)).
:- use_module(library(clpfd)).

p1(L1, L2) :-
    gen(L1, L2),
    test(L2).

gen([], []).
gen(L1, [X | L2]) :-
    select(X, L1, L3),
    gen(L3, L2).

test([_,_]).
test([X1, X2, X3 | Xs]) :-
    (X1 < X2, X2 < X3; X1 > X2, X2 > X3),
    test([X2, X3 | Xs]).

% 1) 
% o gen(L1,L2) copia para L2 a lista L1 que recebe
% e depois testa se para cada elemento da lista l2, que é igual a lista l1
% se para cada grupo de 3 elementos consecutivos se o o primeiro  e menor que o segundo
% o segundo e menor que o terceiro ou se o primeiro e maior que o segundo e o segundo maior que o terceiro.
% Este tipo de algoritmo é do tipo generate and test, o que não é muito
% eficiente uma vez que são geradas todas as listas possiveis, e o
% predicado test encarrega-se de verificar se a lista está ordenada

p2(L1, L2) :-
    length(L1, N),
    length(L2, N),
    %
    pos(L1, L2, Is),
    all_distinct(Is),
    %
    labeling([], Is),
    test(L2).

pos([], _, []).
pos([X|Xs], L2, [I|Is]) :-
    nth1(I, L2, X),
    pos(Xs, L2, Is).

% 2) a) As variáveis de domínio estão a ser instanciadas antes da fase de pesquisa e nem todas as
%       restrições foram colocadas antes da fase da pesquisa 

% 3)
p2(L1,L2) :-
    length(L1,N),
    length(L2,N),
    % generate list
    pos(L1, L2, Is),
    all_distinct(Is),
    % check order
    testOpt(L2),
    %elimante symetry
    length(Aux, N), sorting(Is, Aux, Is),
    % find solutions
    labeling([], Is).

pos([], _, []).
pos([X|Xs], L2, [I|Is]) :-
    element(I, L2, X),
    pos(Xs, L2, Is).

testOpt([_, _]).
testOpt([X1, X2, X3 | Xs]) :-
    (X1 #< X2 #/\ X2 #< X3) #\/ (X1 #> X2 #/\ X2 #> X3),
    testOpt([X2, X3 | Xs]).

% 4)
sweet_recipes(MaxTime, NEggs, RecipeTimes, RecipeEggs, Cookings, Eggs) :-
    length(RecipeTimes, N), length(RecipeEggs, N), 
    length(Cookings, 3), all_distinct(Cookings),
    % restriction of the MaxTime limit
    element(1, Cookings, CookIndex1), element(2, Cookings, CookIndex2), element(3, Cookings, CookIndex3),
    element(CookIndex1, RecipeTimes, Cost1), element(CookIndex2, RecipeTimes, Cost2), element(CookIndex3, RecipeTimes, Cost3),
    Cost1 + Cost2 + Cost3 #< MaxTime,
    % restriction of the packs limit
    element(1, Cookings, CookIndex1), element(2, Cookings, CookIndex2), element(3, Cookings, CookIndex3),
    element(CookIndex1, RecipeEggs, Pack1), element(CookIndex2, RecipeEggs, Pack2), element(CookIndex3, RecipeEggs, Pack3),
    Eggs #= Pack1 + Pack2 + Pack3,
    Eggs #=< NEggs,
    % eliminate symetry
    length(Aux, 3), sorting(Cookings, Aux, Cookings),
    % find solution
    labeling([maximize(Eggs)], Cookings).

% 5)
cut(Shelves, Boards, SelectedBoards) :-
    length(Shelves, N), length(SelectedBoards, N), 
    restrictions(Shelves, Boards, SelectedBoards),
    labeling([], SelectedBoards).

restrictions(Shelves, Boards, SelectedBoards) :-
    makeItems(Shelves, SelectedBoards, Items),
    makeBins(1, Boards, Bins),
    bin_packing(Items, Bins).

makeItems([], [], []).
makeItems([Shelf|Shelfs], [Board|Boards], [item(Board,Shelf)|Items]) :-
    makeItems(Shelfs, Boards, Items).

makeBins(_, [], []).
makeBins(Id, [Board|Boards], [bin(Id, BoardSize)|Bins]) :-
    BoardSize in 0..Board,
    IdNext is Id + 1,
    makeBins(IdNext, Boards, Bins).