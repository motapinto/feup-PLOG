:-use_module(library(clpfd)).

sumProduct(N1,  N2,  N3) :-
domain([A, B, C], 1, 200), 
A*B*C #= A+B+C, 
% Removes duplicates
C#>=B,  B#>=A,    
labeling([], [A, B, C])