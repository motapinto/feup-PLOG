%include library's
:- [game].

printMenu :-
    nl,
    nl,
    write(ooooooooooooooooooooooooooooooooooo),
    nl,
    write('o            ASTERISMO            o'),
    nl,
    write(ooooooooooooooooooooooooooooooooooo),
    nl,
    write('o                                 o'),
    nl,
    write('o       => (1) P & P              o'),
    nl,
    write('o                                 o'),
    nl,
    write('o       => (2) P & Machine        o'),
    nl,
    write('o                                 o'),
    nl,
    write('o       => (3) Machine & Machine  o'),
    nl,
    write('o                                 o'),
    nl,
    write('o       => (4) Exit               o'),
    nl,
    write('o                                 o'),
    nl,
    write(ooooooooooooooooooooooooooooooooooo),
    nl,
    write('o        Created by:              o'),
    nl,
    write('o                                 o'),
    nl,
    write('o      => Martim Silva            o'),
    nl,
    write('o      => Jose Guerra             o'),
    nl,
    write(ooooooooooooooooooooooooooooooooooo),
    nl,
    nl.

selectOption :-
    write('> Insert your option: '),
    menuInputHandler.

menuInputHandler :-
    read(Input),
    (   (Input==1,
startPP)
    ;   (Input==2,
        write('B'))
    ;   (Input==3,
        write('C'))
    ;  (Input==4,
        write('Exiting...')
    ;   selectOption)
    ).

play :-
    printMenu,
    selectOption.
