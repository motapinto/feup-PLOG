%L1 - Lista de elementos
%L2 - L2 é uma lista com todos os elementos de L1 que são unificáveis com Termo
%Termo - Termo qualquer

%   Exemplo:
%   ?- unificavel([X,b,t(Y)], t(a), L).
%   L=[X,t(Y)] 

%   Dica:
%   Note que se Termo1=Termo2 resulta então 
%   not(Termo1 = Termo2) falha e a instanciação resultante
%   de Termo1 = Termo2 é anulada. 

unificavel([], _, []).
unificavel([Head | Tail], Termo, L2) :-
    (
        %   verifica se e unificavel e nao verifica a outra condicao se o que se segue falhar
        not Head=Termo, !, 
        %   if é unifical:
        unificavel(Tail, Termo, [Head | L2])
    )
    ;
    unificavel(Tail, Termo, L2).
