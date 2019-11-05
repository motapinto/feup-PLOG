unificavel([],_,[]).
unificavel([T|Resto],T1,Resto1):-
    (T=T1 -> fail;
        !, unificavel(Resto, T1, Resto1)).

unificavel([T|Resto],T1,[T|Resto1]):- write(T), unificavel(Resto,T1,Resto1). 
        

p2(L):-  unificavel([X,b,t(Y)],t(a),L). 