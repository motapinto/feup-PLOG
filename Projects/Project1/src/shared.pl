% if then else implementation 
if_then_else(P,Q,_):- P, !, Q.
if_then_else(_,_,R):- R.

includes:-
    use_module(library(lists)),
    use_module(library(random)),
    use_module(library(system)).