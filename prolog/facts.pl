:- module(facts, [occasion/1, relationship/1, gender/1, age_group/1, age_group/3, budget/1, budget/3, gift/1, gift/3]).
:- dynamic occasion/1, relationship/1, gender/1, gift/1, gift/3.

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