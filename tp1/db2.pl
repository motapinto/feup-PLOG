% --- pilots list --- %
pilot('Lamb').
pilot('Besenyei').
pilot('Chambliss').
pilot('MacLean').
pilot('Mangold').
pilot('Jones').
pilot('Bonhomme').

% --- teams list --- %
team('Breitling').
team('Red Bull').
team('Mediterranean Racing Team').
team('Cobra').
team('Matador').

% --- pilots teams list --- %
isMemberOfTeam('Lamb', 'Breitling').
isMemberOfTeam('Besenyei', 'Red Bull').
isMemberOfTeam('Chambliss', 'Red Bull').
isMemberOfTeam('MacLean', 'Mediterranean Racing Team').
isMemberOfTeam('Mangold', 'Cobra').
isMemberOfTeam('Jones', 'Matador').
isMemberOfTeam('Bonhomme', 'Matador').

% --- planes list --- %
plane('MX2').
plane('Edge540').

% --- pilots planes list --- %
isPilotOfPlane('Lamb', 'MX2').
isPilotOfPlane('Besenyei', 'Edge540').
isPilotOfPlane('Chambliss', 'Edge540').
isPilotOfPlane('MacLean', 'Edge540').
isPilotOfPlane('Mangold', 'Edge540').
isPilotOfPlane('Jones', 'Edge540').
isPilotOfPlane('Bonhomme', 'Edge540').

% --- circuits list --- %
circuit('Istanbul').
circuit('Budapest').
circuit('Porto').

% --- circuit pilot winners list --- %
pilotWonCircuit('Jones', 'Porto').
pilotWonCircuit('Mangold', 'Budapest').
pilotWonCircuit('Mangold', 'Istanbul').

% --- circuit gates count list --- %
gates('Porto', 5).
gates('Istanbul', 9).
gates('Budapest', 6).

% --- rules list --- %
teamWonCircuit(T, C) :- 
    team(T), 
    circuit(C), 
    pilot(P), 
    pilotWonCircuit(P, C), 
    isMemberOfTeam(P, T).

wonManyCircuits(Pilot) :-
    pilotWonCircuit(Pilot, C1),
    pilotWonCircuit(Pilot, C2),
    circuit(C1),
    circuit(C2),
    C1 @< C2.

bigCircuit(C) :-
    circuit(C),
    gates(C, NumGates),
    NumGates > 8.

noEdge540Pilots(Pilot) :-
    pilot(Pilot),
    \+ isPilotOfPlane(Pilot, 'Edge540').