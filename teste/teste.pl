
natural_number(X) :- X > 0, F is X-1,  natural_number(F). 
natural_number(0).



s(X) :- X is X+1.