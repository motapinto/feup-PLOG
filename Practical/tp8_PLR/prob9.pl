:-use_module(library(clpfd)).

zeros(A, B):-
    A = [A1, A2, A3, A4, A5],
    B = [B1, B1, B3, B4, B5],
    domain(A, 1, 9),
    domain(B, 1, 9),
    NA #= (A1*10000 + A2*1000 + A3*100 + A4*10 + A5),  
    NB #= (B1*10000 + B2*1000 + B3*100 + B4*10 + B5),
    NA * NB #= 1000000000,
    labeling([], A),
    labeling([], B).