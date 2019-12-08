:-use_module(library(clpfd)).

map_coloring(L) :-
    L = [WA, NT, SA, Q, NSW, V, T],
    domain(L, 0, 2), % equivalente a fazer L in 0..2
    WA #\= NT, WA#\=SA,
    NT #\=NT, NT#\=Q,
    write('.'), %ver quantas vezes faz p backtracking -> so imprime uma vez o '.'
    labeling([], L).

% % se fizermos primeiro o labelling o programa fica menos eficiente
% %e sao impressos muitos mais pontos pq havera muito backtracking
% % mal haja uma restricao que falhe faz backtrcking

% %fazendo este metodo se pedir outra solucao o numero de pontos impressos
% % vai variar devido ao backtracking

% %terceira solucao -> prolog de teste 1

% % map_coloring(WA, NT, SA, Q, NSW, V, T):-
% %     MEMBER(...)

% %esta solucao tambem faz muito backtracking e e parecido com a segunda solucao(extamanete igual)
% %isto é fazer primeiro o labelling e dps as restricoes

% %POR ISSO E IMPORTNATE FAZER PRIMEIRO RESTRICOES E DPS LABELLING -> nao ha backtracking




% % se fizermos n ele faz backtracking ate ao labelling


% %podemosfazer A in(2,8) \/ (15..20)
% %A in {4,8,14,24,28}

% in_set()% conjunto de valores posssiveis
% Numbers = [5, 6, 7, 19, 25, 56]
% list_to_fdset(Numbers, FDS_Numbers),
% ?

% domain(List, Min, Max)

% fd_batch?

% reified: restricao nao colocada e variavel a 0
% restricao colocada ou variavel a 1
% constraint #<=> B
% B pode ter valor 0 ou 1

% restricoes globais a maior parte delas nao pode ser materializadas
% as restricoes simples podem ser materializadas


% exactly(X,L,N). % numero de vezes que X aparce em L

exactly(_, [], 0).
exactly(X, [Y|L], N) :-
    X #= Y #<=>B,
    N #= M+B,
    exactly(X,L,M).



Objetivo: otimizar recursos e obter maximo lucro.
Cada obra tem um valor de venda .
Cada obra tem uma data limite.
Se a obra terminar antes da data limite há um bonus.
Se a obra terminar depois da data limite há penalização.
O bonus/penalizacao tem a ver com o numero de dias de diferenca entre o estipulado e o terminado.
Cada obra tem um conjunto operacoes especificas(trabalhadores especializados, material especifico).
Cada trabalhador pode ter mais que 1 especialidade ou ser indiferenciado.
Cada material tem um custo.
Cada trabalhador tem um custo(Quantas mais especialidades tiver mais bem pago é).
Podem haver dependencias/ordem nas operaçoes durante a obra.
Cada fase de especialidade tem um duracao e precisa de pelo menos 1 trabalhador da especialidade.
Dependendo do numero de pessoas alocadas para um fase de especialidade, esta pode ter duracao variavel.
Todos os materiais e trabalhadores estao sempre disponiveis a serem utilizados.
Os materiais e trabalhadores podem ter custos diferentes dependendo di dia.

%   constructionWork(id, Name, DateLimit, Value, ListOfOperations)

    constructionWork(0, 'Bridge', 500000, [0, 1, 2, 3, 4, 5]).
    constructionWork(1, 'Federal building', 1000000, [2, 3, 4]).
    constructionWork(2, 'House', 200000, [0, 2, 4]).
    constructionWork(2, 'Apartament', 300000, [1, 4, 5]).
    constructionWork(2, 'Gas station', 400000, [2, 5, 9]).
    constructionWork(2, 'School building', 250000[3, 4, 10]).
    constructionWork(2, 'Hospital', 1000000, [5, 2, 7, 9, 10]).
    constructionWork(2, 'Police station', 400000, [3, 4, 5, 1]).
    constructionWork(2, 'Shopping', 560000, [10, 2, 1, 3]).
    constructionWork(2, 'Gym', 340000, [0, 2, 3, 5, 9, 10]).

%   constructionOperation(Id, Description, speacialty, listOfWorkers, listOfMaterials)
    constructionOperation(0, 'Glazing', ).

%   worker(Id, Name, ListOfSpeacialty, Salary)
worker(0, 'Oliver', ['Electrician'], 300).
worker(1, 'Jack', ['Carpenter'], 150).
worker(2, 'Charlie', ['Mason'], 150).
worker(3, 'Oscar', ['Engineer', 'Electrician', 'Technician'], 1050).
worker(4, 'James', ['Plumber', 'Carpenter'], 300).
worker(5, 'William', ['Tiler'], 150).
worker(6, 'Thomas', ['Technician'], 250).
worker(7, 'Harry', ['Engineer', 'Technician'], 750).
worker(8, 'Emily', ['Painter', 'Carpenter'], 300).
worker(9, 'Olivia', ['Engineer'], 500).
worker(10, 'Jessica', ['Director'], 900).
worker(11, 'Ava', ['Technician'], 250).
worker(12, 'Isabella', ['Project Manager'], 700).

%   materialAndEquipment(Id, Name, Cost)
materialAndEquipment(0, 'Measuring Tape', 5).
materialAndEquipment(1, 'Eletrical Wiring', 200).
materialAndEquipment(2, 'Steel', 100).
materialAndEquipment(4, 'Wood', 50).
materialAndEquipment(5, 'Glass', 45).
materialAndEquipment(6, 'Stone', 70).
materialAndEquipment(7, 'Cement', 150).
materialAndEquipment(8, 'Safety Helment', 40).
materialAndEquipment(9, 'Safety Vest', 50).
materialAndEquipment(10, 'Gloves', 10).
materialAndEquipment(11, 'Elevator', 2000).
materialAndEquipment(12, 'Escalator', 10000).
materialAndEquipment(13, 'Switches', 200).
materialAndEquipment(14, 'Pickaxe', 40).
materialAndEquipment(15, 'Shovel', 13).
materialAndEquipment(16, 'Crane', 7000).
materialAndEquipment(17, 'Excavator', 13000).
materialAndEquipment(18, 'Bulldozers', 15000).
materialAndEquipment(19, 'Trucks', 9000).






%Resource

%
