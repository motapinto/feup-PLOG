max(X, Y, Z, X):- X>Y, X>Z, !.
max(X, Y, Z, Y):- Y>X, Y>Z, !.
max(_, _, Z, Z). 

%   a) Diga em que situações o programa não funciona correctamente.
%   R: X=5 Y=5 Z=1 e Z é considerado o max. 

%   b) Corrija o programa
max1(X, Y, Z, X):- X>=Y, X>=Z, !.
max1(X, Y, Z, Y):- Y>Z, !.
max1(_, _, Z, Z). 