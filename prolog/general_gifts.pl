:- module(general_gifts, [recommend_general_gifts/2]).
:- use_module(utilities).

% The category items of each general gift is a strict sublist of the given category items
recommend_general_gifts(Categories, Answers) :-
    zip(Categories, Answers, Tuples),
    all_strict_sublists(Tuples, [_|AllTuples]),
    recommend_general_gifts_h(AllTuples).

recommend_general_gifts_h([]).
recommend_general_gifts_h([Tuples|_]) :-
    unzip(Tuples, Categories, Answers),
    G =.. [gift|Answers],
    graceful_call(G, Gift),
    print_with_category_items("A more general gift", Categories, Answers),
    format(" is ~w.~n", [Gift]).
% TODO: iterate through all other recommendations?

recommend_general_gifts_h([_|AllTuples]) :-
    recommend_general_gifts_h(AllTuples).