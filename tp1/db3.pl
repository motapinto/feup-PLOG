book('Os Maias', 'romance').
author('Eça de Queiroz', 'português').
wrote('Eça de Queiroz', 'Os Maias').
nationality('português').
nationality('inglês').
genre('romance').
genre('ficção').


questionB(Author) :-
    author(Author, 'português'),
    wrote(Author, Book),
    book(Book, 'romance').

questionC(Author) :-
    wrote(Author, Book1),
    book(Book1, 'ficção'),
    wrote(Author, Book2),
    book(Book2, Genero),
    Genero \= 'ficção'.