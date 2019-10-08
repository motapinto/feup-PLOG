% 3)Implemente o predicado append(L1,L2,L) em que L é constituída pela concatenação das listas L1 e L2. 

append([], L1, L1).

append([X | L1], L2, [X | L3]):- 
    append(L1, L2, L3). 