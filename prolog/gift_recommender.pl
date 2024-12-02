% Gifterly

:- use_module(utilities).
:- use_module(facts).
:- use_module(alternative_gifts).

% dynamically unifies all items under `Category` to `Items`.
all_items(Category, Items) :- all_items(Category, [], Items).
all_items(Category, U, [I|Items]) :-
    call(Category, I),
    \+ member(I, U),
    !,
    all_items(Category, [I|U], Items).
all_items(_, _, []).

print_serialized_items(Items) :- print_serialized_items(Items, 1).
print_serialized_items([], _) :- write("0: other (Please specify)"), nl.
print_serialized_items([I|Items], N) :-
    unescape(I, U),
    format("~w: ~w", [N, U]), nl,
    M is N + 1,
    print_serialized_items(Items, M).

% prints the prompt for `Category`
print_category_prompt(age_group, Items) :-
    findall((Start, End, Category), age_group(Start, End, Category), AgeGroups),
    format("Choose the age group by its number: (e.g. 1)~n", []),
    print_age_groups(AgeGroups, 1, Items).

print_category_prompt(budget, Items) :-
    findall((Start, End, Category), budget(Start, End, Category), Budgets),
    format("Choose the budget by its number: (e.g. 1)~n", []),
    print_budgets(Budgets, 1, Items).

% Fallback for other categories
print_category_prompt(Category, Items) :-
    format("Choose the ~w by its number: (e.g. 1)~n", [Category]),
    all_items(Category, Items),
    print_serialized_items(Items).

% Print age groups
print_age_groups([], _, []) :- write("0: other (Please specify)"), nl.
print_age_groups([(Start, End, Category) | AgeGroups], N, [Category | Items]) :-
    format("~w: ~w (~w - ~w years)~n", [N, Category, Start, End]),
    M is N + 1,
    print_age_groups(AgeGroups, M, Items).

% Print budgets
print_budgets([], _, []) :- write("0: other (Please specify)"), nl.
print_budgets([(Start, End, Category) | Budgets], N, [Category | Items]) :-
    format("~w: ~w ($~w - $~w)~n", [N, Category, Start, End]),
    M is N + 1,
    print_budgets(Budgets, M, Items).
% prompts user to choose a valid instance of `Category`
% which will be unified to `Item`
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

get_item(age_group, Items, N, Item) :-
    nth1(N, Items, Item).

get_item(budget, Items, N, Item) :-
    nth1(N, Items, Item).

get_item(Category, Items, N, Item) :-
    nth1(N, Items, Item),
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

recommend_general_gifts_h([]).  % Base case: no more recommendations to process
recommend_general_gifts_h([Tuples|AllTuples]) :-
    unzip(Tuples, Categories, Answers),
    G =.. [gift|Answers],
    ( catch(call(G, Gift), _, fail) ->  % If a gift is found
        print_with_category_items("A more general gift", Categories, Answers),
        format(" is ~w.~n", [Gift])
    ; true  % If no gift is found, continue to the next tuple
    ),
    recommend_general_gifts_h(AllTuples).  % Process the next recommendation

recommend_general_gifts_h([_|AllTuples]) :-
    recommend_general_gifts_h(AllTuples).

recommend :-
    recommend([occasion, relationship, gender, age_group, budget]).

recommend(Categories) :-
    prompt_categories(Categories, Answers),
    recommend_gift(Categories, Answers),
    recommend(Categories).

% Sample query
% ?- recommend.
% Enter the occasion (birthday, anniversary, new_year, christmas): new_year.
% Enter the relationship (friend, family, colleague, partner): |: friend.
% Recommendation: a box of cereal
% true.
