:- module(alternative_gifts, [recommend_alternative_gifts/3]).
:- use_module(utilities).

% the category items (A) of each alternative gift overlap with the given category items (C)
% i.e. A ∩ C ≠ ∅, A ≠ C
% FIXME: Stub
recommend_alternative_gifts().

recommend_alternative_gifts([], [], _).
% found an alternative gift
recommend_alternative_gifts(Categories, Answers, _) :-
    G =.. [gift|Answers],
    graceful_call(G, Gift),
    print_with_category_items("An alternative gift", Categories, Answers),
    format(" is ~w.~n", [Gift]).
% TODO: implements recursive fuzzy match
% exhausts a category for alternative items
recommend_alternative_gifts([C|Categories], [A|Answers], Tried) :-
    graceful_call(C, Answer),
    A \= Answer,
    \+ member((C, Answer), Tried),
    recommend_alternative_gifts([C|Categories], [Answer|Answers], [(C, Answer)|Tried]).
% category exhausted, strips it and move on to the following category
recommend_alternative_gifts([_|Categories], [_|Answers], _) :-
    recommend_alternative_gifts(Categories, Answers, []).
% category exhausted, strips it and move on to the following category
recommend_alternative_gifts([_|Categories], [_|Answers], _) :-
    recommend_alternative_gifts(Categories, Answers, []).
