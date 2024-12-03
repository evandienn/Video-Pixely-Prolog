:- module(new_gifts, [suggest_new_gift/1]).
:- use_module(utilities).
:- use_module(facts).

suggest_new_gift(Categories) :-
    suggest_new_gift(Categories, [], []).
suggest_new_gift(Categories, Cs, As) :-
    print_specs_and_gift(Cs, As),
    style_format("Choose an option by entering its number:~n", [], title),
    print_new_gift_menu(Categories),
    read_option(Categories, Cs, As).

print_specs_and_gift([], []) :-
    style_format("There are no specifications.~n", [], information).

%! pretty-prints all specifications and gifts (if any)
print_specs_and_gift(Categories, Answers) :-
    heads_only(Answers, HAs),
    G =.. [gift|HAs],
    (
        graceful_call(G, Gift) -> Prefix = Gift
        ; Prefix = "There are no gifts"
    ),
    print_with_category_items(Prefix, Categories, Answers, ".", information), nl.

specify_category(Category/_, SC) :-
    format(string(SC), "specify the ~w", Category).

print_new_gift_menu(Categories) :-
    maplist(specify_category, Categories, SCs),
    print_serialized_items(SCs, "proceed with suggesting a new gift").

read_option(Categories, Cs, As) :-
    read_number("Choose a valid option", No),
    (
        No = 0 -> prompt_provide_new_gift(Cs, As)
        ; I is No - 1,
          nth0(I, Categories, C),
          category_menu(Categories, C, Cs, As, NewCs, NewAs),
        suggest_new_gift(Categories, NewCs, NewAs)
    ).

get_item(Category/1, _, 0, [Item]) :-
    style_format("Specify the ~w:~n", [Category], specify),
    read_str(Input),
    escape(Input, Item).
get_item(_, Items, N, Item) :-
    nth1(N, Items, Item).

category_menu(Categories, C/N, Cs, As, NewCs, NewAs) :-
    style_format("Specify the ~w by selecting a number (e.g. 1), or leave blank to unspecify:~n", [C], title),
    all_items(C/N, Items),
    display_format(C, Format),
    (
        N = 1 -> Item0 = "other (please specify)"
        ; Item0 = none
    ),
    (
        map_get(C/N, Cs, As, Selected) -> print_serialized_items(Items, Selected, Item0, Format)
        ; print_serialized_items(Items, none, Item0, Format)
    ),
    read_number_or_blank("Please choose a valid option:", NoOrBlank),
    (
        NoOrBlank = blank -> map_unset(C/N, Cs, As, NewCs, NewAs)
        ; get_item(C/N, Items, NoOrBlank, Item),
          ordered_map_put(Categories, C/N, Item, Cs, As, NewCs, NewAs)
    ).


prompt_provide_new_gift(Cs, As) :-
    print_with_category_items("Provide the gift", Cs, As, ":", specify), nl,
    read_str(String),
    add_new_gift(String, Cs, As),
    style_format(String, [], title), print_with_category_items(" will be a new gift", Cs, As, ".", information), nl.

add_new_gift(Gift, Categories, Answers) :-
    assert_list_if_absent(Categories, Answers),
    heads_only(Answers, Hs),
    append(Hs, [Gift], Args),
    Goal =.. [gift|Args],
    catch(\+ call(Goal), _, make_gift_dynamic(Categories)),
    assertz(Goal).

assert_list_if_absent([], []).
assert_list_if_absent([C/_|Categories], [A|Answers]) :-
    Goal =.. [C|A],
    catch(\+ call(Goal), _, make_gift_dynamic(Categories)),
    assertz(Goal),
    assert_list_if_absent(Categories, Answers).
assert_list_if_absent([_|Categories], [_|Answers]) :-
    assert_list_if_absent(Categories, Answers).

make_gift_dynamic(List) :- length(List, N), M is N + 1, dynamic(gift/M).
