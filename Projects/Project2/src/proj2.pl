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

