% 4)Construa um predicado inverter(L1, L2) que calcule a lista invertida de uma dada lista. 

rev([], L2, L2).

inverter(L1, L2):- 
    rev(L1, [], L2). 
    
rev([H|T], S, R):- 
    rev(T, [H|S], R). 