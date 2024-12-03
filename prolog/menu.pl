:- module(menu, [menu/2]).
:- use_module(utilities).

get_option(_, 0, _) :-
    write("Bye!"), nl, fail.
get_option(Options, N, Option) :-
    M is N - 1,
    nth0(M, Options, Option).

menu(Options, Categories) :-
    write("Welcome to Gifterly! Please choose an option:"), nl,
    print_serialized_items(Options, "quit"),
    read_number("Please choose a valid option:", No),
    !,
    get_option(Options, No, Option),
    call(Option, Categories),
    !,
    menu(Options, Categories).
