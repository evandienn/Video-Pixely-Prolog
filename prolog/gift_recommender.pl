% Gift Recommender

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

% Define a rule to recommend a gift based on occasion and relationship
recommend_gift(O, R, G) :-
    occasion(O),
    relationship(R),
    gift(O, R, G).


recommend :-
    write("Enter the occasion (birthday, anniversary, new_year, christmas): "),
    read(O),
    write("Enter the relationship (friend, family, colleague, partner): "),
    read(R),
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
