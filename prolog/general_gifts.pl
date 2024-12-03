:- module(general_gifts, [recommend_general_gifts/2]).
:- use_module(utilities).

% The category items of each general gift is a strict sublist of the given category items
recommend_general_gifts(Categories, Answers) :-
    zip(Categories, Answers, Tuples),
    all_strict_sublists(Tuples, [_|AllTuples]),
    recommend_general_gifts_with_prompt(AllTuples).

recommend_general_gifts_with_prompt([]) :-  % Base case: no more recommendations
    write("No more general gift recommendations available."), nl.
recommend_general_gifts_with_prompt([Tuples|AllTuples]) :-
    unzip(Tuples, Categories, Answers),
    heads_only(Answers, AHs),
    Goal =.. [gift|AHs],
    ( graceful_call(Goal, Gift) ->  % If a gift is found
        print_with_category_items("A more general gift", Categories, Answers),
        format(" is ~w.~n", [Gift]),
        write("Would you like to see more general gift recommendations? (yes/no): "), nl,
        get_yes_or_no(Response),
        ( Response = yes ->
            recommend_general_gifts_with_prompt(AllTuples)  % Continue to the next recommendation
        ; write("No more recommendations will be shown."), nl  % Exit if user says no
        )
    ; recommend_general_gifts_with_prompt(AllTuples)  % Skip to the next recommendation if no gift is found
    ).
