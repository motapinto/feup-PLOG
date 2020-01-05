:-use_module(library(clpfd)).

/*
1 -> YELLOW
2 -> GREEN
3 -> RED
4 -> BLUE
*/

car_traffic2 :-
    % 4 different colors for the 12 cars
    Cars = [C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12],
    domain(Cars, 1, 4),
    % 4 yellows 2 greens 3 reds 3 blues
    global_cardinality(Cars, [1-4, 2-2, 3-3, 4-3]),
    % first and last have same color
    C1 #= C12,
    % second and second to last are the same color
    C2 #= C11,
    % fifth car is blue
    C5 #= 4,
    % every subset of 3 cars have different colors
    distinct_subset_of_three(Cars),
    % there is only one sequence of yellow-green-red-blue
    sequence(Cars, 0),
    % find solutions
    labeling([], Cars),
    print('Car Line: '), write(Cars).

distinct_pairs_of_three([_, _ | []]).
distinct_pairs_of_three([C1, C2, C3 | Rest]) :-
    all_distinct([C1,C2,C3]),
    distinct_pairs_of_three([C2, C3 | Rest]).

sequence([_, _, _ | []], NTimes) :- 
    NTimes #= 1.
sequence([C1, C2, C3, C4 | Rest], NTimes) :-
    (C1 #= 1 #/\ C2 #= 2 #/\ C3 #= 3 #/\ C4 #= 4) #<=>B,
    NTimesAux #= NTimes + B,
    sequence([C2, C3, C4 | Rest], NTimesAux).