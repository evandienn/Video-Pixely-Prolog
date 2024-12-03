:- module(facts, [occasion/1, relationship/1, gender/1, age_group/3, budget/3, gift/1, gift/2, gift/3, gift/4, gift/5, gift/6, display_format/2]).
:- dynamic occasion/1, relationship/1, gender/1, gift/1, gift/2, gift/3, gift/4, gift/5, gift/6.

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

% Age groups
age_group(infant, 0, 5).        % 0 to 5 years
age_group(child, 6, 12).        % 6 to 12 years
age_group(teenager, 13, 17).    % 13 to 17 years
age_group(young_adult, 18, 25). % 18 to 25 years
age_group(adult, 26, 40).       % 26 to 40 years
age_group(middle_aged, 41, 65). % 41 to 65 years
age_group(senior, 66, 120).     % 66 years and above

% Budget categories
budget(low, 0, 20).             % $0 to $20
budget(medium, 21, 100).        % $21 to $100
budget(high, 101, 500).         % $101 to $500
budget(luxury, 501, 5000).      % $501 to $5000
budget(premium, 5001, 10000).   % $5001 and above

% Define possible gifts for each occasion and relationship
% Birthday gifts
gift(birthday, friend, male, young_adult, low, 'a personalized mug').
gift(birthday, family, child, medium, 'a custom photo album').
gift(birthday, colleague, adult, medium, 'a Prolog project list').
gift(birthday, partner, young_adult, luxury, 'a weekend getaway').

% Anniversary gifts
gift(anniversary, friend, young_adult, low, '15 pieces of McDonalds nuggets').
gift(anniversary, family, adult, medium, 'a family outing').
gift(anniversary, colleague, middle_aged, medium, 'a Prolog quiz review session').
gift(anniversary, partner, middle_aged, luxury, 'a spa retreat').

% New Year gifts
gift(new_year, friend, teenager, low, 'a box of cereal').
gift(new_year, family, middle_aged, medium, 'cooking a dish for your family').
gift(new_year, colleague, young_adult, medium, 'a website showcasing your Prolog project').
gift(new_year, partner, young_adult, high, 'a watch').

% Christmas gifts
gift(christmas, friend, teenager, high, 'a PS5').
gift(christmas, family, child, medium, 'a holiday-themed puzzle').
gift(christmas, colleague, adult, low, 'a CPSC 312 sticker').
gift(christmas, partner, middle_aged, medium, 'a handwoven scarf').

% General gifts for occasions
gift(birthday, 'a birthday card').
gift(anniversary, 'a bouquet of flowers').
gift(new_year, 'a box of chocolates').
gift(christmas, 'a holiday ornament').

% General gifts for relationships
gift(friend, 'a photo frame').
gift(family, 'a board game').
gift(colleague, 'a desk organizer').
gift(partner, 'a handwritten letter').

% Gifts by occasion only
gift(birthday, 'a custom birthday cake').
gift(anniversary, 'a romantic dinner voucher').
gift(new_year, 'a festive fireworks kit').
gift(christmas, 'a cozy holiday sweater').

% Most general gift (Worst Gift)
gift("cash").

display_format(age_group, "~w (~w - ~w years)").
display_format(budget, "~w ($~w - $~w)").
display_format(_, "~w").
