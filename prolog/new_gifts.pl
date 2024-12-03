:- module(new_gifts, [new_gift/1, prompt_add_new_gift/3]).
:- use_module(utilities).
:- use_module(facts).

new_gift(Categories) :-
    new_gift(Categories, [], []).
new_gift(Categories, Cs, As) :-
    print_specs_and_gift(Cs, As),
    write("Choose an option by entering its number:"), nl,
    print_new_gift_menu(Categories),
    read_option(Categories, Cs, As).

print_specs_and_gift([], []) :-
    write("There are no specifications."), nl.

%! pretty-prints all specifications and gifts (if any)
print_specs_and_gift(Categories, Answers) :-
    heads_only(Answers, HAs),
    G =.. [gift|HAs],
    (
        graceful_call(G, Gift) -> Prefix = Gift
        ; Prefix = "There are no gifts"
    ),
    print_with_category_items(Prefix, Categories, Answers), write("."), nl.

specify_category(Category/_, SC) :-
    format(string(SC), "specify the ~w", Category).

print_new_gift_menu(Categories) :-
    maplist(specify_category, Categories, SCs),
    print_serialized_items(SCs, "proceed with suggesting a new gift").

read_option(Categories, Cs, As) :-
    read_number("Choose a valid option", No),
    (
        No = 0 -> custom_gift(Cs, As)
        ; I is No - 1,
          nth0(I, Categories, C),
          category_menu(Categories, C, Cs, As, NewCs, NewAs),
          new_gift(Categories, NewCs, NewAs)
    ).

get_item(Category, _, 0, Item) :-
    format("Specify the ~w:~n", [Category]),
    read_str(Input),
    escape(Input, Item).
get_item(_, Items, N, Item) :-
    M is N - 1,
    nth0(M, Items, Item).

category_menu(Categories, C/N, Cs, As, NewCs, NewAs) :-
    format("Specify the ~w by selecting a number (e.g. 1), or leave blank to unspecify:~n", [C]),
    all_items(C/N, Items),
    display_format(C, Format),
    (
        map_get(C/N, Cs, As, Selected) -> print_serialized_items(Items, Selected, "other (please specify)", Format)
        ; print_serialized_items(Items, none, "other (please specify)", Format)
    ),
    read_number_or_blank("Please choose a valid option:", NoOrBlank),
    (
        NoOrBlank = blank -> map_unset(C/N, Cs, As, NewCs, NewAs)
        ; get_item(C, Items, NoOrBlank, Item),
          ordered_map_put(Categories, C/N, Item, Cs, As, NewCs, NewAs)
    ).


custom_gift(Cs, As) :-
    print_with_category_items("Provide the gift", Cs, As), write(":"), nl,
    read_str(String),
    add_new_gift(String, Cs, As),
    write(String), print_with_category_items(" will be a new gift", Cs, As), nl.

prompt_add_new_gift(Gift, Categories, Answers) :-
    format(string(Prefix), "Add ~w as a gift", [Gift]),
    print_with_category_items(Prefix, Categories, Answers), write("? (yes or no)"), nl,
    get_yes_or_no(YesOrNo),
    (
        YesOrNo = yes -> add_new_gift(Gift, Categories, Answers)
        ; nl
    ).

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
