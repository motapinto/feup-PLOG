passaro('Tweety').
peixe('Goldie').
minhoca('Molie').
gato('Silvester').

gostaDe(passaro, minhoca).
gostaDe(gato, peixe).
gostaDe(gato, passaro).
gostaDe(amigo, amigo).

amigoDe(gato, eu).
amigoDe(eu, gato).

gatoCome(Y) :-
    amigoDe(gato, Y) ; gostaDe(gato, Y).
