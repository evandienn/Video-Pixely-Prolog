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
gender(others).

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

% dynamically unifies all items under `Category` to `Items`.
all_items(Category, Items) :- all_items(Category, [], Items).
all_items(Category, U, [I|Items]) :-    
    call(Category, I),
    \+ member(I, U),        
    !,
    all_items(Category, [I|U], Items).
all_items(_, _, []).

% FIXME: may change to a selection menu
% prints the prompt for `Category`
print_category_prompt(Category) :-
    all_items(Category, Items),
    atomic_list_concat(Items, ", ", Atom),            
    format("Enter the ~w (~w):", [Category, Atom]), nl.

% prompts user to choose a valid instance of `Category`
% which will be unified to `Result`
prompt_category(Category, Result) :-
    print_category_prompt(Category),
    prompt_category_h(Category, yes(Result)).

prompt_category_h(Category, yes(Input)) :-    
    read(Input),
    call(Category, Input).
prompt_category_h(Category, Result) :- 
    format("Please enter a valid ~w:", [Category]), nl,
    prompt_category_h(Category, Result).


% Define a rule to recommend a gift based on occasion and relationship
recommend_gift(O, R, Gift) :-
    occasion(O),
    relationship(R),
    gift(O, R, Gift).


recommend :-
    prompt_category(occasion, O),
    prompt_category(relationship, R),
    prompt_category(gender, Gender),
    % TODO: prompt for age_group, e.g. "how old are they?"
    % TODO: prompt for budget
    (recommend_gift(O, R, Gift) ->
        write("Recommendation: "), write(Gift), nl
    ;
        write("No gift found, please enter valid occasion and relationship."), nl
    ).


% Sample query
% ?- recommend.
% Enter the occasion (birthday, anniversary, new_year, christmas): new_year.
% Enter the relationship (friend, family, colleague, partner): |: friend.
% Recommendation: a box of cereal
% true.
