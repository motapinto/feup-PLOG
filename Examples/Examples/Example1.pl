% Exemplo de selecção customizada de variáveis/valoresFicheiro
:-use_module(library(clpfd)).
:-use_module(library(lists)).

inicio([X,Y]) :-
	X in 1..6,
	Y in 1..4,
%	X #< Y,
	labeling([],[X,Y]),
%	labeling([variable(mySelVariaveis)],[X,Y]),
%	labeling([value(mySelValores)],[X,Y]),
%	labeling([variable(mySelVariaveis),value(mySelValores)],[X,Y]),
	write(X-Y),write('  '),fail.
inicio(_) :- nl.

%% Heuristica de Seleccao de Variaveis - ff (implementada � m�o)
mySelVariaveis([V|Vars], X, Rest) :-
	fd_size(V, S),
	seleccao(Vars, V, S, X, Rest).

seleccao([], X, _, X, []).
seleccao([V|Vars], V0, S0, X, Rest) :-
	integer(V), !,
	seleccao(Vars, V0, S0, X, Rest).
seleccao([V|Vars], V0, S0, X, [Y|Rest]) :-
	fd_size(V, S),
	(   
	  S<S0 -> Y=V0, seleccao(Vars, V, S, X, Rest)
	  ;   
	  Y=V, seleccao(Vars, V0, S0, X, Rest)
        ).

%% Heuristica de Seleccao de Valores - Ordena��o por Custo Estatico
mySelValores(Var, _Rest, BB, BB1) :-
	fd_set(Var, Set),
	select_best_value(Set, Value, _),
	(   
	   first_bound(BB, BB1), Var #= Value
           ;   
	   later_bound(BB, BB1), Var #\= Value
        ).

% Selecciona Melhor Valor (o que tem menor Custo)
select_best_value(Set, BestValue, BestCost):-
	findall(Cost-Value, (fdset_member(Value, Set), cost(Value, Cost)), Lista),
	keysort(Lista, Lista2),
	Lista2 = [BestCost-BestValue|_].

% Seleccao de Valores com ordem: 6 3 4 5 2 1
cost(1,6).
cost(2,5).
cost(3,2).
cost(4,3).
cost(5,4).
cost(6,1).