r(a,b).
r(a,c). 
r(b,a). 
r(a,d).


s(b,c). 
s(b,d). 
s(c,c). 
s(d,e). 


% terminal: spy r, spy s. 
% terminal: r(X,Y), s(Y,Z), \+ r(Y,X), \+ s(Y,Y).
/*
a)
| ?- r(X,Y), s(Y,Z), \+ r(Y,X), \+ s(Y,Y).
 +      1      1 Call: r(_879,_919) ? 
?+      1      1 Exit: r(a,b) ? 
 +      2      1 Call: s(b,_1033) ? 
?+      2      1 Exit: s(b,c) ? 
        3      1 Call: call(user:r(b,a)) ? 
 +      4      2 Call: r(b,a) ? 
 +      4      2 Exit: r(b,a) ? 
        3      1 Exit: call(user:r(b,a)) ? 
 +      2      1 Redo: s(b,c) ? 
 +      2      1 Exit: s(b,d) ? 
        5      1 Call: call(user:r(b,a)) ? 
 +      6      2 Call: r(b,a) ? 
 +      6      2 Exit: r(b,a) ? 
        5      1 Exit: call(user:r(b,a)) ? 
 +      1      1 Redo: r(a,b) ? 
?+      1      1 Exit: r(a,c) ? 
 +      7      1 Call: s(c,_1033) ? 
 +      7      1 Exit: s(c,c) ? 
        8      1 Call: call(user:r(c,a)) ? 
 +      9      2 Call: r(c,a) ? 
 +      9      2 Fail: r(c,a) ? 
        8      1 Fail: call(user:r(c,a)) ? 
       10      1 Call: call(user:s(c,c)) ? 
 +     11      2 Call: s(c,c) ? 
 +     11      2 Exit: s(c,c) ? 
       10      1 Exit: call(user:s(c,c)) ? 
 +      1      1 Redo: r(a,c) ? 
?+      1      1 Exit: r(b,a) ? 
 +     12      1 Call: s(a,_1033) ? 
 +     12      1 Fail: s(a,_1033) ? 
 +      1      1 Redo: r(b,a) ? 
 +      1      1 Exit: r(a,d) ? 
 +     13      1 Call: s(d,_1033) ? 
 +     13      1 Exit: s(d,e) ? 
       14      1 Call: call(user:r(d,a)) ? 
 +     15      2 Call: r(d,a) ? 
 +     15      2 Fail: r(d,a) ? 
       14      1 Fail: call(user:r(d,a)) ? 
       16      1 Call: call(user:s(d,d)) ? 
 +     17      2 Call: s(d,d) ? 
 +     17      2 Fail: s(d,d) ? 
       16      1 Fail: call(user:s(d,d)) ? 
X = a,
Y = d,
Z = e ? ;
no
*/
% fazer assim para as outras perguntas