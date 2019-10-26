isPrime(2).

y_divides_x(X,Y) :-
    0 is X mod Y. % left argument must be constant

y_divides_x(X,Y) :-
    X > Y+1,
    y_divides_x(X, Y+1).

isPrime(X) :-
    X > 1,
    \+(y_divides_x(X, 2)).
    