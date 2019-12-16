:-use_module(library(clpfd)).

zebra :-
    Solution = [Houses, Nacionality, Drinks, Animal, Smokes],
    
    Houses = [Red, Green, White, Yellow, Blue],
    Nacionality = [EN, ES, NOR, UCR, PT],
    Drinks = [Coffee , Water, Milk, Tea, Juice],
    Animal = [Dog , Horse, Zebra, Fox, Iguana],
    Smokes = [Che , LS, SG, Marlboro, Winston],

    List = [
        Red, Green, White, Yellow, Blue,
        EN, ES, NOR, UCR, PT,
        Coffee , Water, Milk, Tea, Juice,
        Dog , Horse, Zebra, Fox, Iguana,
        Che , LS, SG, Marlboro, Winston
    ],

    domain(List, 1, 5),

    all_distinct(Houses),
    all_distinct(Nacionality),
    all_distinct(Drinks),
    all_distinct(Animal),
    all_distinct(Smokes),

    EN #= Red, ES #= Dog, NOR #= 1,
    Yellow #= Marlboro,
    Che #= Rap + 1 #\/ Che #= Rap - 1,
    NOR #= Blue + 1 #\/ NOR #= Blue - 1,
    Winston #= Iguana,
    LS #= Juice,
    UCR #= Tea,
    PT #= SG,
    Marlboro #= Horse + 1 #\/ Marlboro #= Horse - 1,
    Green #= Coffee,
    Green #= White + 1,
    Milk #= 3,

    labeling([], List),
    nl, write(Solution), nl, nl.

