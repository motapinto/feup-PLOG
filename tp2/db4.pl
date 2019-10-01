  
fibonacci(0,1).
fibonacci(1,1).

fibonacci(N,F):- 
    N > 1,
    N1 is N-1,
    N2 is N1-1, 

    fibonacci(N1,F1),
    fibonacci(N2,F2),
    F is F1 + F2. 

