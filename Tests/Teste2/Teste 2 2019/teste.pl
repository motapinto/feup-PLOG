:- use_module(library(lists)).
:- use_module(library(clpfd)).

pres(N, K, Vars):-
    length(Vars, N),
    domain(Vars, 1, K),
    indices(1, Vars),
    labeling([], Vars).

indices(_, []).
indices(I, [V|Vs]) :-
    V mod 2 #\= I mod 2,
    I1 is I+1,
    indices(I1, Vs).

% 3)
% nos indices pares (0,2,4,..) tem de estar um valor de K pares
% uma vez que o I comeca em 1, nos indices nao pares(1,3,5,..) 
% tem de estar um valor de K impar

% 4) Não

% 5)
constroi_binarias(_, _, _, []).
constroi_binarias(I, K, Vars, [LBin|LBins]) :-
    I =< K, !,
    constroi_bins(I, Vars, LBin),
    I1 is I+1,
    constroi_binarias(I1, K, Vars, LBins).

constroi_bins(_, [], []).
constroi_bins(I, [H|T], [LBinH|LBinT]) :-
    I #= H #<=>LBinH,
    constroi_bins(I, T, LBinT).

% 6)
% Criar um predicado flatten que faça a conversão da lista de listas
% para uma lista. Depois com o predicado bin packing calcular os compartimentos
% para cada um dos objetos. Antes do labeling fazer a retricao do peso

% 7)
prat(Prateleiras, Objetos, Vars) :-
    length(Objetos, N), length(Vars, N),
    keys_and_values(Objetos, Pesos, Volumes),
    flatten(Prateleiras, PratFlatten),
    write(Volumes), nl, write(PratFlatten), nl,
    %transpose(Volumes, VolumesT),
    %sumPesos()
    %restrictPesos(VolumesT, Pesos),
    makeItems(Vars, Volumes, Items),
    makeBins(PratFlatten, 1, Bins),    
    bin_packing(Items, Bins),
    labeling([], Vars).

makeItems([], [], []).
makeItems([Bin | Bins], [Volume | Volumes], [item(Bin, Volume) | Items]):- 
    makeItems(Bins, Volumes, Items).

makeBins([], _, []).
makeBins([Prateleira | Prateleiras], Id, [bin(Id, BinSize) | Bins]):-
    BinSize in 0..Prateleira,
    NextID is Id + 1,
    makeBins(Prateleiras, NextID, Bins).

% 8)
% Através do uso do predicado cumulative. Sabendo que cada tarefa tem uma serie de requisitos
% Tem uma duraçao, numero de recursos alocados, etc
% Assim é necessario criar um predicado que crie a lista de tasks com essas informacoes
% e depois cahamar o predicado cumulative com as Tasks retornadas no predicado referido anteriormente
% 9)
flatten([], []).
flatten([H | T], Ret):-
    flatten(T, NL),
    appTo(H, NL, Ret).

appTo([], L, L).
appTo([H|T], L, [H|NL]):-
    appTo(T, L, NL).

objeto(piano, 3, 30).
objeto(cadeira, 1, 10).
objeto(cama, 3, 15).
objeto(mesa, 2, 15).
homens(4).
tempo_max(60).

furniture:-
    findall(Requirement, objeto(_, Requirement, _), Requirements),
    findall(Time, objeto(_, _, Time), Durations),
    tempo_max(TempoMax), length(Durations, NumTasks),
    length(InitialTimes, NumTasks), domain(InitialTimes, 0, TempoMax),
    length(EndTimes, NumTasks), domain(EndTimes, 0, TempoMax),
    homens(Homens), maximum(End, EndTimes),
    taskMaker(InitialTimes, Durations, EndTimes, Requirements, 1, Tasks),
    cumulative(Tasks, [limit(Homens)]),
    labeling([minimize(End)], InitialTimes),
    write(InitialTimes), nl, write(EndTimes).

taskMaker([], [], [], [], _, []).
taskMaker([InitialTime | InitialTimes], [Duration | Durations], [EndTime | EndTimes], [Requirement | Requirements], TaskID, [task(InitialTime, Duration, EndTime, Requirement, TaskID) | Tasks]):-
    NextTaskID is TaskID + 1,
    taskMaker(InitialTimes, Durations, EndTimes, Requirements, NextTaskID, Tasks).