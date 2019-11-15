:- [shared].
:- [game].

%   Prints de main menu of the game
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
    write('|       > (1) Player & Player        |'),
    nl,
    write('|                                    |'),
    nl,
    write('|       > (2) Player & Machine       |'),
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

%   Handler of user input in the menu
menuInputHandler :-
    write('> Insert your option: '),
    read(Input),
    if_then_else(
        (
            Input == 1;
            Input == 2;
            Input == 3
        ),
        (
            if_then_else(
                (Input == 2 ; Input == 3),   
                readDifficulty(Level1, 1),
                true
            ),
            if_then_else(
                    (Input == 3),   
                    readDifficulty(Level2, 2),
                    Level2 = Level1
                ),
            if_then_else(
                start(Input, Level1, Level2),
                true,
                play
            )
        ),
            if_then_else(
                Input == 4,
                true,
                (
                    write('Select a valid option!\n'),
                    menuInputHandler
                )
            )
    ). 

%   Reads the level of difficulty of the machine user
readDifficulty(Level, I) :-
    write('\n> (0) AI level 0\n'),
    write('> (1) AI level 1\n'),
    format('Chose Level for machine ~d: ', I), 
    read(LevelAux),
    if_then_else(
        (
            LevelAux == 0;
            LevelAux == 1
        ),
        Level = LevelAux,
        readDifficulty(Level)
    ).


%   Prints the menu and handles the user input
play :-
    includes,
    printMenu,
    menuInputHandler.
