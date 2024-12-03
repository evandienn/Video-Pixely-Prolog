% Gifterly

:- use_module(utilities).
:- use_module(facts).
:- use_module(general_gifts).
:- use_module(alternative_gifts).
:- use_module(new_gifts).
:- use_module(menu).

% Fallback for other categories
print_category_prompt(Category/N, Items) :-
    unescape_format("Choose the ~w by its number: (e.g. 1)~n", [Category]),
    all_items(Category/N, Items),
    display_format(Category, Format),
    (
        N = 1 -> Item0 = "other (please specify)"
        ; Item0 = none
    ),
    print_serialized_items(Items, none, Item0, Format).

% prompts user to choose a valid instance of `Category`
% which will be unified to `Item`
prompt_category(Category/N, Item) :-
    print_category_prompt(Category/N, Items),
    unescape(Category, UCategory),
    format(string(Question), "Enter a valid number for the ~w:~n", [UCategory]),
    read_number(Question, ItemNo),
    get_item(Category/N, Items, ItemNo, Item),
    display_format(Category, Format),
    format(string(Formatted), Format, Item),
    unescape_format("Ok, the ~w is ~w.~n", [Category, Formatted]).

prompt_assert_if_absent(Category, _, Item) :-
    C =.. [Category, Item],
    call(C).
prompt_assert_if_absent(Category, Input, Item) :-
    unescape_format("Do you want to add ~w into ~w? (enter yes or no)~n", [Input, Category]),
    get_yes_or_no(YN),
    (
        YN = yes ->
            C =.. [Category, Item],
            catch(\+ call(C), _, dynamic(Category/1)),
            assertz(C)
        ; nl
    ).

get_item(Category/1, _, 0, [Item]) :-
    format("Specify the ~w:~n", [Category]),
    read_str(Input),
    escape(Input, Item),
    prompt_assert_if_absent(Category, Input, Item).
get_item(_, Items, N, Item) :-
    nth1(N, Items, Item).

prompt_categories([], []).
prompt_categories([Category|Cs], [Answer|As]) :-
    prompt_category(Category, Answer),
    prompt_categories(Cs, As).


% Define a rule to recommend a gift based on category choices
recommend_gift(Categories, Answers) :-
    heads_only(Answers, Hs),
    G =.. [gift|Hs],
    graceful_call(G, Gift),
    print_with_category_items("The Gift", Categories, Answers),
    format(" is ~w.~n", [Gift]).

% Recommends a more general gift if no exact gift was found
recommend_gift(Categories, Answers) :-
    print_with_category_items("There is no exact gift", Categories, Answers), write("."), nl, !,
    recommend_general_gifts(Categories, Answers).

%! The entry point for the recommend gift option
recommend(Categories) :-
    prompt_categories(Categories, Answers),
    recommend_gift(Categories, Answers).

% The designated entry point of the program
recommend :-
    menu([recommend/1, suggest_new_gift/1], [occasion/1, relationship/1, gender/1, age_group/3, budget/3]).

% Sample query
% ?- recommend.
% Enter the occasion (birthday, anniversary, new_year, christmas): new_year.
% Enter the relationship (friend, family, colleague, partner): |: friend.
% Recommendation: a box of cereal
% true.
