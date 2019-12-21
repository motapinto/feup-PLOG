:-use_module(library(clpfd)).

kid(Products) :-
    Products = [Rice, Potatoes, Spaghetti, Tuna],
    domain(Products, 1, 711),
    % the sum of all products is the same as the multiplication of all products
    %Rice + Potatoes + Spaghetti + Tuna #= Rice * Potatoes * Spaghetti * Tuna,
    % the sum of all products is 7.11€
    Rice + Potatoes + Spaghetti + Tuna #= 711,
    % potatoes is more expensive than tuna
    Potatoes #> Tuna,
    % tuna is more expensive than rice
    Tune #> Rice,
    % spaghetti is the chepeast product
    Spaghetti #< Tuna,
    % two of the products are multiples of 10 cents
    (
        (A is Rice mod 10, B is Potatoes mod 10, A == 0, B == 0) ; 
        (Rice mod 10, Spaghetti mod 10) ; 
        (Rice mod 10, Tuna mod 10) ; 

        (Potatoes mod 10, Spaghetti mod 10) ; 
        (Potatoes mod 10, Tuna mod 10) ; 

        (Spaghetti mod 10, Tuna mod 10)
    ),
    labeling([], Products).
