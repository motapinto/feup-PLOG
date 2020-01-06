:-use_module(library(clpfd)).

magicHex(List) :-
    List = [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S],
    domain(List, 1, 19),
    all_distinct(List),

    A + B + C #= 38,
    A + B + C #= D + E + F + G,
    A + B + C #= H + I + J + K + L,
    A + B + C #= M + N + O + P,
    A + B + C #= Q + R + S,

    A + D + H #= 38,
    A + D + H #= B + E + I + M,
    A + D + H #= C + F + J + N + Q,
    A + D + H #= G + K + O + R,
    A + D + H #= L + P + S,

    C + G + L #= 38,
    C + G + L #= B + F + K + P,
    C + G + L #= A + E + J + O + S,
    C + G + L #= D + I + N + R,
    C + G + L #= H + M + Q,

    labeling([], List).
