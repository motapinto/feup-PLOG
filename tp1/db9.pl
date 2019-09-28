aluno(joao, paradigmas).
aluno(maria, paradigmas).
aluno(joel, lab2).
aluno(joel, estruturas).

frequenta(joao, feup).
frequenta(maria, feup).
frequenta(joel, ist).

professor(carlos, paradigmas).
professor(ana_paula, estruturas).
professor(pedro, lab2).

funcionario(pedro, ist).
funcionario(ana_paula, feup).
funcionario(carlos, feup).

alunosDoProf(ProfX) :-
    aluno(A, D),
    professor(ProfX, D).

daUniversidade(Uni) :-
    frequenta(Pessoa, Uni) ;
    funcionario(Pessoa, Uni).

colegas(P1, P2) :-
    aluno(P1, Cadeira), aluno(P2, Cadeira) ;
    frequenta(P1, Faculdade), frequenta(P2, Faculdade) ;
    funcionario(P1, Faculdade), funcionario(P2, Faculdade).        


