%include library's
:- [game].

printMenu :-
    nl,
    nl,
    write('|------------------------------------|'),
    nl,
    write('|             ASTERISMO              |'),
    nl,
    write('|------------------------------------|'),
    nl,
    write('|                                    |'),
    nl,
    write('|       > (1) P & P                  |'),
    nl,
    write('|                                    |'),
    nl,
    write('|       > (2) P & Machine            |'),
    nl,
    write('|                                    |'),
    nl,
    write('|       > (3) Machine & Machine      |'),
    nl,
    write('|                                    |'),
    nl,
    write('|       > (4) Exit                   |'),
    nl,
    write('|                                    |'),
    nl,
    write('|------------------------------------|'),
    nl,
    write('|        Created by:                 |'),
    nl,
    write('|                                    |'),
    nl,
    write('|       o Martim Silva               |'),
    nl,
    write('|       o Jose Guerra                |'),
    nl,
    write('|------------------------------------|'),
    nl,
    nl.

selectOption :-
    write('> Insert your option: '),
    menuInputHandler.

menuInputHandler :-
    read(Input),
    Input==1,
    startPP.
play :-
    printMenu,
    selectOption.
