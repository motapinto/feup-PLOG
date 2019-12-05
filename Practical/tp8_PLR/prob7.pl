:-use_module(library(clpfd)).

peru(PUni, PTot):-
    PTot in 670..9679,
    Max in 0..9,
    Min in 0..9,
    PUni in 1..9679,
    PTot #= PUni * 72,
    PTot #= 1000 * Max + 670 + Min,
    labeling([],[PTot, PUni]).

