:-use_module(library(clpfd)).

count_equals(_, [], 0).
count_equals(Val, [Curr | Next], Count) :-   
    Curr #= Val #<=> B,
    Count #= M + B,
    count_equals(Val, Next, M).