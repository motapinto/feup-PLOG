% % select(?X, ?Xlist, ?Y, ?Ylist)
% % is true when X is the Kth member of Xlist and Y 
% the Kth element of Ylist for some K, and apart from 
% that Xlist and Ylist are the same. You can use it to 
% replace X by Y or vice versa. Either Xlist or Ylist should be a proper list.


% ?- select(b, [a,b,c,b], 2, X).
% X = [a, 2, c, b] ;
% X = [a, b, c, 2] ;
% false.

addElemInList(PosToReplace, In, NewValue, Out) :-
    
    