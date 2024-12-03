:- module(menu, [menu/2]).
:- use_module(utilities).

get_option(_, 0, _) :-
    write("Bye!"), nl, fail.
get_option(Options, N, Option) :-
    nth1(N, Options, Option).

destructure_preds([], []).
destructure_preds([Name/_|Preds], [Name|Names]) :-
    destructure_preds(Preds, Names).

menu(Options, Categories) :-
    destructure_preds(Options, DOptions),
    menu_internal(DOptions, Categories).
menu_internal(Options, Categories) :-
    write("Welcome to Gifterly! Please choose an option:"), nl,
    print_serialized_items(Options, "quit"),
    read_number("Please choose a valid option:", No),
    !,
    get_option(Options, No, Option),
    call(Option, Categories),
    !,
    menu_internal(Options, Categories).
