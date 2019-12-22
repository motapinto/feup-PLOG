:-use_module(library(clpfd)).

kid(Products) :-
    Products = [Rice, Potatoes, Spaghetti, Tuna],
    domain(Products, 0, 711),
    % the sum of all products is the same as the multiplication of all products
    Rice * Potatoes * Spaghetti * Tuna #= 711,
    % the sum of all products is 7.11€
    Rice + Potatoes + Spaghetti + Tuna #= 711,
    % potatoes is more expensive than tuna
    Potatoes #> Tuna,
    % tuna is more expensive than rice
    Tune #> Rice,
    % spaghetti is the chepeast product
    Spaghetti #< Rice,
    % two of the products are multiples of 10 cents
    (
        (A #= Rice mod 10, B #= Potatoes mod 10, A == 0, B == 0) ; 
        (A #= Rice mod 10, B #= Spaghetti mod 10, A == 0, B == 0) ; 
        (A #= Rice mod 10, B #= Tuna mod 10, A == 0, B == 0) ; 

        (A #= Potatoes mod 10, B #= Spaghetti mod 10, A == 0, B == 0) ; 
        (A #= Potatoes mod 10, B #= Tuna mod 10, A == 0, B == 0) ; 

        (A #= Spaghetti mod 10, B #= Tuna mod 10, A == 0, B == 0)
    ),
    labeling([], Products).
