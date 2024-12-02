% Gifterly

:- use_module(utilities).
:- use_module(facts).
:- use_module(alternative_gifts).
:- use_module(new_gifts).
:- use_module(menu).

%! prints the prompt for Category
print_category_prompt(Category, Items) :-
    format("Choose the ~w by its number: (e.g. 1)~n", [Category]),
    all_items(Category, Items),
    print_serialized_items(Items, "other (please specify)").

%! prompts user to choose a valid instance of `Category`
%  which will be unified to `Item`
prompt_category(Category, Item) :-
    print_category_prompt(Category, Items),
    format(string(Question), "Enter a valid number for the ~w:~n", [Category]),
    read_number(Question, ItemNo),
    get_item(Category, Items, ItemNo, Item),
    unescape(Item, U),
    format("Ok, the ~w is ~w.~n", [Category, U]).

prompt_assert_if_absent(Category, _, Item) :-
    C =.. [Category, Item],
    call(C).
prompt_assert_if_absent(Category, Input, Item) :-
    format("Do you want to add ~w into ~w? (enter yes or no)~n", [Input, Category]),
    get_yes_or_no(YN),
    (
        YN = yes ->
            C =.. [Category, Item],
            catch(\+ call(C), _, dynamic(Category/1)),
            assertz(C)
        ; nl
    ).

get_item(Category, _, 0, Item) :-
    format("Specify the ~w:~n", [Category]),
    read_str(Input),
    escape(Input, Item),
    prompt_assert_if_absent(Category, Input, Item).
get_item(Category, Items, N, Item) :-
    M is N - 1,
    nth0(M, Items, Item),
    call(Category, Item).

prompt_categories([], []).
prompt_categories([Category|Cs], [Answer|As]) :-
    prompt_category(Category, Answer),
    prompt_categories(Cs, As).


% Define a rule to recommend a gift based on category choices
recommend_gift(Categories, Answers) :-
    G =.. [gift|Answers],
    graceful_call(G, Gift),
    print_with_category_items("The Gift", Categories, Answers),
    format(" is ~w.~n", [Gift]).

% Recommends a more general gift if no exact gift was found
recommend_gift(Categories, Answers) :-
    print_with_category_items("There is no exact gift", Categories, Answers), write("."), nl, !,
    recommend_general_gifts(Categories, Answers).

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

recommend :-
    menu([recommend, new_gift], [occasion, relationship, gender]).

recommend(Categories) :-
    prompt_categories(Categories, Answers),
    % TODO: prompt for age_group, e.g. "how old are they?"
    % TODO: prompt for budget
    recommend_gift(Categories, Answers).

% Sample query
% ?- recommend.
% Enter the occasion (birthday, anniversary, new_year, christmas): new_year.
% Enter the relationship (friend, family, colleague, partner): |: friend.
% Recommendation: a box of cereal
% true.
