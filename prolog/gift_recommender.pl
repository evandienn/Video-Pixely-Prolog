% Gifterly

:- use_module(utilities).

% Define types of occasions
occasion(birthday).
occasion(anniversary).
occasion(new_year).
occasion(christmas).

% Define types of relationships
relationship(friend).
relationship(family).
relationship(colleague).
relationship(partner).

gender(male).
gender(female).

age_group(0, 12, kid).
age_group(13, 18, teen).
age_group(19, 30, young_adult).
age_group(31, 50, middle_age).
age_group(senior).

budget(0, 10, m).
budget(11, 100, mm).
budget(101, 1000, mmm).
budget(mmmm).

% Define possible gifts for each occasion and relationship
gift(birthday, friend, 'a personalized mug').
gift(birthday, family, 'a custom photo album').
gift(birthday, colleague, 'a Prolog project list').
gift(birthday, partner, 'a weekend getaway').

gift(anniversary, friend, '15 pieces of mcdonalds nuggets').
gift(anniversary, family, 'a family outing').
gift(anniversary, colleague, 'a Prolog quiz review session').
gift(anniversary, partner, 'a spa retreat').

gift(new_year, friend, 'a box of cereal').
gift(new_year, family, 'cooking a dish for your family').
gift(new_year, colleague, 'a website showcasing your prolog project').
gift(new_year, partner, 'a watch').

gift(christmas, friend, 'a ps5').
gift(christmas, family, 'a holiday-themed puzzle').
gift(christmas, colleague, 'a CPSC 312 sticker').
gift(christmas, partner, 'a handwoven scarf').

gift("cash").

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
print_category_prompt(Category, Items) :-
    format("Choose the ~w by its number: (e.g. 1)~n", [Category]),
    all_items(Category, Items),
    print_serialized_items(Items).

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
            dynamic(Category/1),
            C =.. [Category, Item],
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

% Pretty-prints the given category items
print_with_category_items(Prefix, [], []) :- write(Prefix).
print_with_category_items(Prefix, Categories, Answers) :-
    write(Prefix), write(" when "),
    print_with_category_items(Categories, Answers).
print_with_category_items([C], [A]) :-
    format("the ~w is ~w", [C, A]).
print_with_category_items([C1, C2], [A1, A2]) :-
    format("the ~w is ~w and the ~w is ~w", [C1, A1, C2, A2]).
print_with_category_items([C|Categories], [A|Answers]) :-
    format("the ~w is ~w, ", [C, A]),
    print_with_category_items(Categories, Answers).

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

recommend :-
    recommend([occasion, relationship, gender]).

recommend(Categories) :-
    prompt_categories(Categories, Answers),
    % TODO: prompt for age_group, e.g. "how old are they?"
    % TODO: prompt for budget
    recommend_gift(Categories, Answers),
    recommend(Categories).

% Sample query
% ?- recommend.
% Enter the occasion (birthday, anniversary, new_year, christmas): new_year.
% Enter the relationship (friend, family, colleague, partner): |: friend.
% Recommendation: a box of cereal
% true.
