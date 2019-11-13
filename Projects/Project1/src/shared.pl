% include library's
includes:-
    use_module(library(lists)),
    use_module(library(random)),
    use_module(library(system)).

% if then else implementation
if_then_else(P,Q,_):- P, !, Q.
if_then_else(_,_,R):- R.


replace(_, _, [], []).
replace(O, R, [O|T], [R|T2]) :- replace(O, R, T, T2).
replace(O, R, [H|T], [H|T2]) :- H \= O, replace(O, R, T, T2).

addElemInList(PosToReplace, In, NewValue, Out) :-
    nth0(PosToReplace, In, ElemToReplace),
    replace(ElemToReplace, In, NewValue, Out).

iterateElemInList(PosToReplace, In, Out) :-
    nth0(PosToReplace, In, ElemToReplace),
    NewValue is ElemToReplace + 1,
    replace(ElemToReplace, In, NewValue, Out).


% substitute(+X, +Xlist, +Y, ?Ylist)
% Xlist and Ylist are equal except for replacing identical occurrences of X by Y. Example:
% | ?- substitute(1, [1,2,3,4], 5, X).

% X = [5,2,3,4] ? 

% yes