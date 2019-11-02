imaturo(X):- adulto(X), !, fail.
imaturo(X).
adulto(X):- pessoa(X), !, idade(X, N), N>=18.
adulto(X):- tartaruga(X), !, idade(X, N), N>=50. 

%Green cut: only improves efficiency
%Red cut: Proper placement of the cut operator and the order of the rules is required to determine their logical meaning

% No primeiro cut como a relacao e mutuamente exclusiva
% apos verificar que X e adulto nao vai verificar a outra condicao
% "imaturo(X)." e dá sempre fail sempre que é adulto
% " É um Cut Vermelho pois é essencial para o funcionamento do programa." 

% No segundo cut, outra vez, como e umarealcao mutuamente exclusiva,
% (ou e tartaruga ou adulto) confirmando se que e pessoa mesmo que 
% a idade da pessoa seja inferior a 18 nao verifica a condicao de baixo
% uma vez que se é pessoa nao e tartaruga e vice-versa
% "É um Cut verde pois não altera as soluções obtidas mas sim a eficiência do programa,"
% uma vez que e desnecessario verificar que e tartaruga se ja se procou que é uma pessoa