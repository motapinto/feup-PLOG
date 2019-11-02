dados(um).
dados(dois).
dados(tres).

cut_teste_a(X) :- dados(X).
cut_teste_a('ultima_clausula').
%   --------------------------------------------------------------
%a) Qual o resultado da seguinte pergunta?
%   ?- cut_teste_a(X), write(X), nl, fail.
%   R: X = um ; X = dois ; X = tres ; X = ultima_clausula ; no
%   --------------------------------------------------------------

cut_teste_b(X):- dados(X), !.
cut_teste_b('ultima_clausula'). 
%   --------------------------------------------------------------
%b) Qual o resultado do seguinte programa com um Cut no final da primeira clausula?
%   ?- cut_teste_b(X), write(X), nl, fail.
%   R: X = um ; no
%   --------------------------------------------------------------

cut_teste_c(X,Y) :- dados(X), !, dados(Y).
cut_teste_c('ultima_clausula'). 
%   --------------------------------------------------------------
%c) Qual o resultado do seguinte programa com um Cut no meio dos dois objectivos?
%   ?- cut_teste_c(X,Y), write(X-Y), nl, fail. 
%   R: X=um, Y=um;  X=um, Y=dois; X=um, Y=tres; no
%   --------------------------------------------------------------