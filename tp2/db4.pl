factorial(1,1).
fibonacci(0,1).
fibonacci(1,1).

factorial(N,F):-
    N > 1,
    Ni is N-1,
    factorial(Ni, Fi),
    
    F is N*Fi.

fibonacci(N,F):- 
    N > 1,
    N1 is N-1,
    N2 is N1-1, 

    fibonacci(N1,F1),
    fibonacci(N2,F2),
    F is F1 + F2. 