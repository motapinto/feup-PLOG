:-use_module(library(clpfd)).

send(Vars):-
    Vars=[S,E,N,D,M,O,R,Y],
    domain(Vars,0,9),
    all_distinct(Vars),
    S #\= 0, M #\= 0,
    S*1000 + E*100 + N*10 + D + M*1000 + O*100 + R*10 + E #=
    M*10000 + O*1000 + N*100 + E*10 + Y,
    labeling([],Vars).

sendGen(List1, List2, List3, Vars) :-
    length(List1, Lenght),
    length(List2, Lenght),
    length(List3, Lenght),

    addVars(List1, Vars1),
    addVars(List2, Vars2),
    addVars(List3, Vars3),

    domain(Vars, 0, 9),
    all_distinct(Vars),
    labeling([],Vars).

    
