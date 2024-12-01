% Gift Recommender

% allows runtime modifications
:- dynamic occasion/1, relationship/1, gender/1, gift/3.

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
gift([birthday, friend], 'a personalized mug').
gift([birthday, family], 'a custom photo album').
gift([birthday, colleague], 'a Prolog project list').
gift([birthday, partner], 'a weekend getaway').

gift([anniversary, friend], '15 pieces of mcdonalds nuggets').
gift([anniversary, family], 'a family outing').
gift([anniversary, colleague], 'a Prolog quiz review session').
gift([anniversary, partner], 'a spa retreat').

gift([new_year, friend], 'a box of cereal').
gift([new_year, family], 'cooking a dish for your family').
gift([new_year, colleague], 'a website showcasing your prolog project').
gift([new_year, partner], 'a watch').

gift([christmas, friend], 'a ps5').
gift([christmas, family], 'a holiday-themed puzzle').
gift([christmas, colleague], 'a CPSC 312 sticker').
gift([christmas, partner], 'a handwoven scarf').

% dynamically unifies all items under `Category` to `Items`.
all_items(Category, Items) :- all_items(Category, [], Items).
all_items(Category, U, [I|Items]) :-
    call(Category, I),
    \+ member(I, U),
    !,
    all_items(Category, [I|U], Items).
all_items(_, _, []).

substitute([], _, _, []).
substitute(_, C, C, _).
substitute([Old|L], Old, New, [New|R]) :-
    Old \= New,
    substitute(L, Old, New, R).
substitute([H|L], Old, New, [H|R]) :-
    H \= Old,
    substitute(L, Old, New, R).

unescape(I, S) :-
    atom_chars(I, Chars),
    substitute(Chars, '_', ' ', NChars),
    string_chars(S, NChars).

escape(S, I) :-
    string_chars(S, Chars),
    substitute(Chars, ' ', '_', NChars),
    atom_chars(I, NChars).

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
    prompt_category_h(Category, Items, Item),
    unescape(Item, U),
    format("Ok, the ~w is ~w.~n", [Category, U]).

get_item(Category, _, 0, Item) :-
    format("Specify the ~w:~n", [Category]),
    read(Input),
    !,
    escape(Input, Item).
get_item(Category, Items, N, Item) :-
    integer(N),
    M is N - 1,
    nth0(M, Items, Item),
    call(Category, Item).

prompt_category_h(Category, Items, Item) :-
    read(Input),
    !,
    get_item(Category, Items, Input, Item).
prompt_category_h(Category, Items, Item) :-
    format("Enter a valid number for the ~w:~n", [Category]),
    prompt_category_h(Category, Items, Item).

prompt_categories([], []).
prompt_categories([Category|Cs], [Answer|As]) :-
    prompt_category(Category, Answer),
    prompt_categories(Cs, As).

conditions([C], [A]) :-
    format("the ~w is ~w", [C, A]).
conditions([C1, C2], [A1, A2]) :-
    format("the ~w is ~w, and the ~w is ~w", [C1, A1, C2, A2]).
conditions([C|Categories], [A|Answers]) :-
    format("the ~w is ~w, ", [C, A]),
    conditions(Categories, Answers).

% Define a rule to recommend a gift based on occasion and relationship
recommend_gift(Categories, Answers) :-
    gift(Answers, Gift),
    write("The Gift for "),
    conditions(Categories, Answers),
    format(" is ~w.~n", [Gift]).

% Attempts to recommend an alternative gift if no exact gift was found
recommend_gift(Categories, Answers) :-
    format("There is no exact gift for "),
    conditions(Categories, Answers), write("."), nl,
    recommend_alternative_gifts(Categories, Answers, []).

recommend_alternative_gifts([], [], _).
% found an alternative gift
recommend_alternative_gifts(Categories, Answers, _) :-
    gift(Answers, Gift),
    write("An alternative gift for "),
    conditions(Categories, Answers),
    format(" is ~w.~n", [Gift]).
% TODO: implements recursive fuzzy match
% exhausts a category for alternative items
recommend_alternative_gifts([C|Categories], [A|Answers], Tried) :-
    call(C, Answer),
    A \= Answer,
    \+ member(tried(C, Answer), Tried),
    recommend_alternative_gifts([C|Categories], [Answer|Answers], [tried(C, Answer)|Tried]).
% category exhausted, strips it and move on to the following category
recommend_alternative_gifts([_|Categories], [_|Answers], _) :-
    recommend_alternative_gifts(Categories, Answers, []).

recommend :-
    recommend([gender, occasion, relationship]).

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
