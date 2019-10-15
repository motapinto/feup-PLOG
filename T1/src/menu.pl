printMenu :- 
    nl, nl,
    write('ooooooooooooooooooooooooooooooooooo'), nl, 
    write('o            ASTERISMO            o'), nl,
    write('ooooooooooooooooooooooooooooooooooo'), nl,
    write('o                                 o'), nl,
    write('o       => (1) P V P              o'), nl,
    write('o                                 o'), nl,
    write('o       => (2) P V Machine        o'), nl,
    write('o                                 o'), nl,
    write('o       => (3) Machine V Machine  o'), nl,
    write('o                                 o'), nl,
    write('o       => (4) exit               o'), nl,
    write('o                                 o'), nl,
    write('ooooooooooooooooooooooooooooooooooo'), nl,
    write('o        Created by:              o'), nl,
    write('o                                 o'), nl,
    write('o      => martim silva            o'), nl,
    write('o      =>  jose guerra            o'), nl,
    write('ooooooooooooooooooooooooooooooooooo'), nl, nl.

selectOption :-
    write('> Insert your option: '),
    menuInputHandler.


menuInputHandler :-
    read(Input),
    (
        Input == 1, write('A');
        Input == 2, write('B');
        Input == 3, write('C');
        Input == 4, write('Exiting...');
        selectOption
    ).

selectMenu :- 
    printMenu,
    selectOption.
