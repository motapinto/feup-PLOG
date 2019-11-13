% include library's
includes:-
    use_module(library(lists)),
    use_module(library(random)),
    use_module(library(system)).

% if then else implementation
if_then_else(P,Q,_):- P, !, Q.
if_then_else(_,_,R):- R.

% replace(+list, +Index, +Value, -NewList)
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

changeElemInList(PosToReplace, In, NewValue, Out) :-
    replace(In, PosToReplace, NewValue, Out).

incrementElemInList(PosToReplace, In, Out) :-
    nth0(PosToReplace, In, ElemToReplace),
    NewValue is ElemToReplace + 1,
    replace(In, PosToReplace, NewValue, Out).


% substitute(+X, +Xlist, +Y, ?Ylist)
% Xlist and Ylist are equal except for replacing identical occurrences of X by Y. Example:
% | ?- substitute(1, [1,2,3,4], 5, X).

% X = [5,2,3,4] ? 

% yes