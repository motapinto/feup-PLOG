% if then else implementation 
if_then_else(P,Q,_):- P, !, Q.
if_then_else(_,_,R):- R.

