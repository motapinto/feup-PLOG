% Exemplo de utilização de predicados de estatísticasFicheiro
:- use_module(library(clpfd)).

problem(Vars) :-
	length(Vars,10),
	domain(Vars,1,100),
	
	all_distinct(Vars),
	
	Vars = [V|Vs],
	maximum(V,Vars),
	sum(Vs,#=,V),
	
	reset_timer,
	labeling([],Vars),
%	labeling([down],Vars),
	print_time,
	fd_statistics.



reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.