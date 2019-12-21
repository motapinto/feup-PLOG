% Programação em Lógica com Restrições – PLR / CLP
% Problema de Satisfação de Restrições – PSR / CSP
% Problema de Otimização com Restrições – POR / COP

% fd_batch/1 (mais eficiente que colocar uma restricao de cada vez - suspende mecanismo de propagação)
    % domain([A, B, C], 5, 12), 
    % fd_batch([A #> 8, B + C #< 12, A + B + C #= 20]).

%Reified / restrições materializadas [Constraint #<=> B] -> se Constraint é verdade e B não é colocado B=0 senão B=1
    %exemplo: X #= Y #<=> B : B=0 se X!=Y B=1 se X=Y
    %exemplo: X #= Y #<=> 1 : Restrição X=Y é colocada
    %exemplo: X #= Y #<=> 0 : Restrição X!=Y é colocada (negaçao da restrição)

    %exemplo:
        % X #= 10, 
        % B #= (X#>=2) + (X#>=4) + (X#>=8).
        % B = 3 (resposta)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Pertença
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% in/2
    % VarA in (2..8) \/ (15..20).
    % VarB in {4, 8, 15, 16, 23, 42}.
    % VarC in (2..8) /\ (15..20) \ (5..4).
    % VarcD in -1..5.

% domain/3
    % domain([A, B, C], 5, 12).

% in_set/2
% list_to_fdset/2
    % Numbers = [4, 8, 15, 16, 23, 42],
    % list_to_fdset(Numbers, FDS_Numbers), 
    % Var in_set FDS_Numbers.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aritmética [#= | #\= | #< | #=< | #> | #>=] (podem ser materializadas)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sum/3 -> nao pode ser materializada
    % domain([X,Y], 1, 10), 
    % sum([X,Y], #<, 10).
    % sum([X,Y], #=, Z).

% maximum/2 -> nao pode ser materializada
% minimum/2 -> nao pode ser materializada
    % domain([A,B], 1, 10), ´
    % C in 5..15,minimum(C, [A,B]).
    % A in 5..10,B in 5..10,C in 5..10

% scalar_product/3 scalar_product/4 scalar_product/5 scalar_product/6 ?


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preposicional [X #= 4 #\/ Y #= 6]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P#/\Q  -> verdadeira se as restrições P e Q são ambas verdadeiras (AND)
% P#\/Q  -> verdadeira se pelo menos uma das restrições P e Q é verdadeira (OR)
% #\Q    -> verdadeira se a restrição Q for falsa (NOT)
% P#\Q   -> verdadeira se exatamente uma das restrições P e Q é verdadeira (XOR)
% P#=>Q
% Q#<=P  -> verdadeira se a restrição Q é verdadeira ou se a restrição P é falsa (implicação)
% P#<=>Q -> verdadeira se P e Q são ambas verdadeiras ou ambas falsas (equivalência)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Combinatoria
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global_cardinality/2 global_cardinality/3
    % Verdadeira se cada elemento de Xs é igual a um K e para cada 
    % par K-V exatamente V elementos de Xs são iguais a K

    % global_cardinality([A,B,C],[1-2,3-1]).
    % A in{1}\/{3},
    % B in{1}\/{3},
    % C in{1}\/{3} 

% all_different/1 all_different/2
    % domain([X,Y,Z], 1, 2),
    % all_different([X,Y,Z]).
        % X in 1..2, Y in 1..2, Z in 1..2

% all_distinct/1 all_distinct/2
    % domain([X,Y,Z], 1, 2),
    % all_distinct([X,Y,Z]).
        % no

%nvalue/2 [versão relaxada de all_distinct/2]
    % domain([X,Y], 1, 3),
    % domain([Z], 3, 5), 
    % nvalue(2, [X,Y,Z]),
    % X#\=Y, X#=1.
        % X = 1, Y = 3, Z = 3

% assignment/2 assignment/3 (atribui valores a uma lista) ?

% sorting/3 ? 

% keysorting/2 keysorting/3

% lex_chain/1 lex_chain/2

% element/3

%relation/3

% table/2 table/3

% case/3 case/4

% circuit/1 circuit/2

% cumulative/1 cumulative/2

% cumulatives/2 cumulatives/3

% multi_cumulative/2 multi_cumulative/3

% bin_packing/2

% disjoint1/1 disjoint1/2

% disjoint2/1 disjoint2/2

% geost/2 geost/2 geost/3

% value_precede_chain/2 value_precede_chain/3

% automaton/3 automaton/8 automaton/9

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enumeração
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% indomain/1

% labeling/2

% solve/2

% variable/1

% value/1

% time_out/2

% minimize/2 minimize/3

% maximize/2 maximize/3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estatisticas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% fd_statistics/0 fd_statistics/2

% statistics/0 statistics/2