:-use_module(library(clpfd)).

/*
1 -> BLUE
2 -> YELLOW
3 -> GREEN
4 -> BLACK
*/

car_traffic:-
    % 4 cars with different sizes and colours
    Positions = [YellowP, GreenP, BlueP, BlackP],
    Sizes = [_, GreenS, _, _],
    domain(Positions, 1, 4), all_distinct(Positions),
    domain(Sizes, 1, 4), all_distinct(Sizes),
    % car before blue car is smaller than the car after the blue car
    BeforeBlue #= BlueP - 1,
    AfterBlue #= BlueP + 1,
    element(BeforeIndex, Positions, BeforeBlue),
    element(BeforeIndex, Sizes, BeforeBlueSize),

    element(AfterIndex, Positions, AfterBlue),
    element(AfterIndex, Sizes, AfterBlueSize),
    BeforeBlueSize #< AfterBlueSize,
    % green is the smallest
    GreenS #= 1,
    % green after blue
    GreenP #> BlueP,
    % yellow after black
    YellowP #> BlackP,
    % find solutions
    append(Positions, Sizes, AllVars),
    labeling([], AllVars),
    print('Position: '), write(Positions), nl,
    print('Size: '), write(Sizes).