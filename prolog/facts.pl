:- module(facts, [occasion/1, relationship/1, gender/1, age_group/3, budget/3, gift/1, gift/2, gift/3, gift/6]).
:- dynamic occasion/1, relationship/1, gender/1, gift/1, gift/2, gift/3, gift/6.

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
age_group(0, 5, infant).        % 0 to 5 years
age_group(6, 12, child).        % 6 to 12 years
age_group(13, 17, teenager).    % 13 to 17 years
age_group(18, 25, young_adult). % 18 to 25 years
age_group(26, 40, adult).       % 26 to 40 years
age_group(41, 65, middle_aged). % 41 to 65 years
age_group(66, 120, senior).     % 66 years and above

% Budget categories
budget(0, 20, low).             % $0 to $20
budget(21, 100, medium).        % $21 to $100
budget(101, 500, high).         % $101 to $500
budget(501, 5000, luxury).      % $501 to $5000
budget(5001, 10000, premium).   % $5001 and above

% Define possible gifts for each occasion and relationship
% Birthday gifts
gift(birthday, friend, male, young_adult, low, 'a personalized mug').
gift(birthday, family, any, child, medium, 'a custom photo album').
gift(birthday, colleague, any, adult, medium, 'a Prolog project list').
gift(birthday, partner, any, young_adult, luxury, 'a weekend getaway').

% Anniversary gifts
gift(anniversary, friend, any, young_adult, low, '15 pieces of McDonalds nuggets').
gift(anniversary, family, any, adult, medium, 'a family outing').
gift(anniversary, colleague, any, middle_aged, medium, 'a Prolog quiz review session').
gift(anniversary, partner, any, middle_aged, luxury, 'a spa retreat').

% New Year gifts
gift(new_year, friend, any, teenager, low, 'a box of cereal').
gift(new_year, family, any, middle_aged, medium, 'cooking a dish for your family').
gift(new_year, colleague, any, young_adult, medium, 'a website showcasing your Prolog project').
gift(new_year, partner, any, young_adult, high, 'a watch').

% Christmas gifts
gift(christmas, friend, any, teenager, high, 'a PS5').
gift(christmas, family, any, child, medium, 'a holiday-themed puzzle').
gift(christmas, colleague, any, adult, low, 'a CPSC 312 sticker').
gift(christmas, partner, any, middle_aged, medium, 'a handwoven scarf').

% General gifts for occasions
gift(birthday, any, 'a birthday card').
gift(anniversary, any, 'a bouquet of flowers').
gift(new_year, any, 'a box of chocolates').
gift(christmas, any, 'a holiday ornament').

% General gifts for relationships
gift(any, friend, 'a photo frame').
gift(any, family, 'a board game').
gift(any, colleague, 'a desk organizer').
gift(any, partner, 'a handwritten letter').

% Gifts by occasion only
gift(birthday, 'a custom birthday cake').
gift(anniversary, 'a romantic dinner voucher').
gift(new_year, 'a festive fireworks kit').
gift(christmas, 'a cozy holiday sweater').

% Most general gift (Worst Gift)
gift("cash").