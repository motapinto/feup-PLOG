:-use_module(library(clpfd)).
:-use_module(library(lists)).

buildTasks([], [], [], [], [], []).
buildTasks([H1 | T1], [H2 | T2], [St | Sts], [Et | Ets], [V | Vs], [Task | Tasks]):-
    (Task #= task(St, H1, Et, 1, 1) #<=> B1) #\ (Task #= task(St, H2, Et, 1, 2) #<=> B2),
    V #= B1 * 1 + B2 * 2,
    buildTasks(T1, T2, Sts, Ets, Vs, Tasks).

tasking(V, End):-
    length(V, 4),
    domain(V, 1, 2),
    global_cardinality(V, [1-2, 2-2]),

    length(StartTimes, 4),
    domain(StartTimes, 0, 150),

    length(EndTimes, 4),
    domain(EndTimes, 0, 150),

    buildTasks([45,78,36,29],[49,72,43,31], StartTimes, EndTimes, V, Tasks),

    Machines = [
        machine(1, 1),
        machine(2, 1)
    ],

    maximum(End, EndTimes),

    cumulatives(Tasks, Machines),
    labeling([minimize(End)], V).