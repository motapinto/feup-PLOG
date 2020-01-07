:- use_module(library(lists)).

p1(L1, L2) :-
    gen(L1, L2),
    test(L2).

% select/3 -> The result of removing an occurrence of Element in List is List2.
% retira um elemento da lista L1 e insere na lista 2
gen([], []).
gen(L1, [X | L2]) :-
    select(X, L1, L3),
    gen(L3, L2).

% para cada grupo de 3 elementos consecutivos têm que estar ordenados
% por ordem decrescente ou decrescente
test([_, _]).
test([X1, X2, X3 | Xs]) :-
    (X1 < X2, X2 < X3; X1 > X2, X2 > X3),
    test([X2, X3 | Xs]).

% 1) 
% recebe 1 lista em L1 e gera para L2 uma lista igual à lista L1.
% depois disso, verifica que para cada grupo de 3 elementos consecutivos 
% têm que estar ordenados por ordem crescente ou decrescente nao podendo haver elementos iguais

%2) Não é possível etiquetar Is, pois estas variáveis não têm domínio definido, e nem todas as restrições foram colocadas antes da fase da pesquisa.

:- use_module(library(clpfd)).
% 3)
p2(L1,L2) :-
    length(L1,N),
    length(L2,N),
    % generate list
    pos(L1, L2, Is),
    all_distinct(Is),
    %elimante symetry
    length(Aux, N), sorting(Is, Aux, Is),
    % check order
    testOpt(L2),
    % find solutions
    labeling([], Is).

pos([], _, []).
pos([X|Xs], L2, [I|Is]) :-
    nth1(I, L2, X),
    pos(Xs, L2, Is).

testOpt([_, _]).
testOpt([X1, X2, X3 | Xs]) :-
    (X1 #< X2, X2 #< X3; X1 #> X2, X2 #> X3),
    testOpt([X2, X3 | Xs]).

% 4)
build(Budget, NPacks, ObjectCosts, ObjectPacks, Objects, UsedPacks) :-
    length(ObjectCosts, N), length(ObjectPacks, N), 
    length(Objects, 3), all_distinct(Objects),
    % restriction of the budget limit
    element(1, Objects, ObjIndex1), element(2, Objects, ObjIndex2), element(3, Objects, ObjIndex3),
    element(ObjIndex1, ObjectCosts, Cost1), element(ObjIndex2, ObjectCosts, Cost2), element(ObjIndex3, ObjectCosts, Cost3),
    Cost1 + Cost2 + Cost3 #< Budget,
    % restriction of the packs limit
    element(1, Objects, ObjIndex1), element(2, Objects, ObjIndex2), element(3, Objects, ObjIndex3),
    element(ObjIndex1, ObjectPacks, Pack1), element(ObjIndex2, ObjectPacks, Pack2), element(ObjIndex3, ObjectPacks, Pack3),
    UsedPacks #= Pack1 + Pack2 + Pack3,
    UsedPacks #=< NPacks,
    % elimante symetry
    length(Aux, 3), sorting(Objects, Aux, Objects),
    % find solution
    labeling([maximize(UsedPacks)], Objects).

% 5)
cut(Boards, Shelves, SelectedBoards):-
    length(Shelves, NumShelves),
    length(Boards, NumBoards),
    length(SelectedBoards, NumShelves),
    domain(SelectedBoards, 1, NumBoards),
    makeItems(SelectedBoards, Shelves, Items),
    makeBins(Boards, 1, Bins),    
    bin_packing(Items, Bins),
    labeling([], SelectedBoards).

makeItems([], [], []).
makeItems([Bin | Bins], [Shelf | Shelves], [item(Bin, Shelf) | Items]):- 
    makeItems(Bins, Shelves, Items).

makeBins([], _, []).
makeBins([Board | Boards], Id, [bin(Id, BinSize) | Bins]):-
    BinSize in 0..Board,
    NextID is Id + 1,
    makeBins(Boards, NextID, Bins).
