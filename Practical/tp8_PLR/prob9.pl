:-use_module(library(clpfd)).
:-use_module(library(lists)).

zero(Vars):-
    Vars=[A, B],
    domain(Vars, 1, 100000000),
    A * B #= 1000000000,
    A #>= B,
    nozeros(A), 
    nozeros(B), !,
    labeling([], Vars).


nozeros(X):-
    X #< 10; 
    (   
        Aux #= X mod 10,
        Aux #\= 0,
        Aux1 #= X//10,
        nozeros(Aux1)
    ).
