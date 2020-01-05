:-use_module(library(clpfd)).

% Harp - 1 
% Violin - 2  
% Piano - 3

threeMusicians :-
    % three different people play 3 different instruments
    Musicians = [Anthony, John, Francis], 
    domain(Musicians, 1, 3),
    all_distinct(Musicians),
    % Pianist trains alone (because anthony is not the painist and john trains not alone)
    Francis #= 3,
    % John trains with the violin guy 
    John #\= 2,
    % find solutions
    labeling([], Musicians),
    print('Musicians: '), write(Musicians).

% Musicians: [2,1,3] -> Anthony:Violin ;  John:Harp ; Francis:Piano
    