:-use_module(library(clpfd)).
:-use_module(library(lists)).

% 3 by 3 version
magic(Vars) :-
    Vars=[A1, A2, A3, A4, A5, A6, A7, A8, A9], 
    domain(Vars,  1,  9), 

    all_distinct(Vars), 

    A1 + A2 + A3 #= Soma, 
    A4 + A5 + A6 #= Soma, 
    A7 + A8 + A9 #= Soma, 
    A1 + A4 + A7 #= Soma, 
    A2 + A5 + A8 #= Soma, 
    A3 + A6 + A9 #= Soma, 
    A1 + A5 + A9 #= Soma, 
    A3 + A5 + A7 #= Soma, 
    
    % Eliminar simetrias
    A1 #< A2, 
    A1 #< A3,  
    A1 #< A4,  
    A2 #< A4,

    labeling([], Vars).

% N by N version
magic(N, Vars) :-
    Limit is N*N,
    length(Vars, N),
    domain(Vars, 1, Limit),

    restrictions(Vars),
    all_distinct(Vars),
    labeling([], Vars).

restrictions([]).
restrictions([H|T]) :-
    aux(),
    restrictions(T).