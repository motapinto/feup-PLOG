book('Os Maias', 'romance').
author('Eça de Queiroz', 'português').
wrote('Eça de Queiroz', 'Os Maias').
nationality('português').
nationality('inglês').
genre('romance').
genre('ficção').


questionB(Author) :-
    author(Author, 'português'),
    wrote(Author, book),
    book(book, 'romance').

questionC(Author) :-
    wrote(Author, book1),
    book(book1, 'ficção'),
    wrote(Author, book2),
    book(book2, Genero),
    Genero \= 'ficção'.

% ---
% Answers to exercises:
% a) wrote(author, 'Os Maias')
% b) questionB(author)
% c) questionC(author)
% ---