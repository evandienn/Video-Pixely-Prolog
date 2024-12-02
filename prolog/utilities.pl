:- module(utilities,
    [
        graceful_call/2,
        zip/3,
        unzip/3,
        all_strict_sublists/2,
        unescape/2,
        escape/2,
        read_str/1,
        read_number_or_blank/2,
        read_number/2,
        get_yes_or_no/1,
        print_with_category_items/3,
        print_serialized_items/1,
        print_serialized_items/2,
        print_serialized_items/3,
        all_items/2,
        ordered_map_put/7,
        map_get/4,
        map_unset/5
    ]).

%! graceful_call(+Goal, -V)
%
%  invokes call(Goal, V) and gracefully fails encountering an error
graceful_call(Goal, V) :- catch(call(Goal, V), _, fail).

zip([], _, []).
zip(_, [], []).
zip([X|Xs], [Y|Ys], [(X,Y)|Zs]) :- zip(Xs, Ys, Zs).

unzip([], [], []).
unzip([(X,Y)|Zs], [X|Xs], [Y|Ys]) :- unzip(Zs, Xs, Ys).

compare_by_length_then_intrinsic(Delta, Sub1, Sub2) :-
    length(Sub1, Len1), length(Sub2, Len2),
    ( Len1 < Len2 -> Delta = '>'
    ; Len1 > Len2 -> Delta = '<'
    ; compare(Delta, Sub2, Sub1)
    ).

%! all_strict_sublists(+List, -SubLists)
%
%  unifies all strict sublists of List to SubLists
%
%  SubLists is sorted by the length of the sublists in descending order
all_strict_sublists(List, SubLists) :-
    all_strict_sublists([], List, Unsorted),
    predsort(compare_by_length_then_intrinsic, Unsorted, SubLists).

all_strict_sublists(Prefix, [H|List], SubLists) :-
    append(Prefix, [H], Prefix2),
    all_strict_sublists(Prefix, List, SubLists1),
    all_strict_sublists(Prefix2, List, SubLists2),
    append(SubLists1, SubLists2, SubLists).

all_strict_sublists(Prefix, [], [Prefix]).

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

read_str(String) :-
    read_string(user_input, "\n", "\r\t ", _, String).

read_number_or_blank(_, NoOrBlank) :-
    read_str(Input),
    (
        atom_number(Input, No) -> NoOrBlank = No
        ; Input = "" -> NoOrBlank = blank
    ).
%! read_number_or_blank(+Question, -NoOrBlank)
% 
%  keeps reading from user input (whitespace-trimmed and line break delineated)
%  until getting a number or blank
%
%  prompts Question everytime an invalid input was read
read_number_or_blank(Question, NoOrBlank) :-
    write(Question), nl,
    read_number_or_blank(Question, NoOrBlank).

%! read_number(+Question, -No)
% 
%  keeps reading from user input (whitespace-trimmed and line break delineated)
%  until getting a number
%
%  prompts Question everytime an invalid input was read
read_number(Question, No) :- 
    read_number_or_blank(Question, No),
    No \= blank.

%! get_yes_or_no(-YesOrNo)
%
%  keeps reading from user input (whitespace-trimmed and line break delineated)
%  until getting 'yes' or 'no' (case-insensitive)
%
%  prompts "Please enter yes or no." everytime an invalid input was read
get_yes_or_no(YesOrNo) :-
    read_str(YN),
    string_lower(YN, LYN),
    (
      LYN = "yes" -> YesOrNo = yes
    ; LYN = "no" -> YesOrNo = no
    ; write("Please enter yes or no."), nl, get_yes_or_no(YesOrNo)
    ).

print_with_category_items(Prefix, [], []) :- 
    write(Prefix).
%! print_with_category_items(+Prefix, +Categories, +Answers)
% 
%  pretty prints the given category items
print_with_category_items(Prefix, Categories, Answers) :-
    write(Prefix), write(" when "),
    print_with_category_items(Categories, Answers).
print_with_category_items([C], [V]) :-
    format("the ~w is ~w", [C, V]).
print_with_category_items([K1, C2], [V1, A2]) :-
    format("the ~w is ~w and the ~w is ~w", [K1, V1, C2, A2]).
print_with_category_items([C|Categories], [V|Answers]) :-
    format("the ~w is ~w, ", [C, V]),
    print_with_category_items(Categories, Answers).

%! print_serialized_items(+Items)
% 
print_serialized_items(Items) :- 
    print_serialized_items(Items, none).
%! print_serialized_items(+Items, +Item0)
% 
print_serialized_items(Items, Item0) :- 
    print_serialized_items(Items, none, Item0).
%! print_serialized_items(+Items, +Selected, +Item0)
% enumerates and prints Items with a 1-based counter in ascending order
%
% prints an extra ✔️ before eol if the line item = Selected  
%
% prints an extra line at the end if Item0 \= none
print_serialized_items(Items, Selected, Item0) :- 
    print_serialized_items(Items, Selected, 1, Item0).
print_serialized_items([], _, _, none).
print_serialized_items([], _, _, Item0) :- 
    Item0 \= none,
    format("0: ~w~n", [Item0]).
print_serialized_items([I|Items], Selected, N, Item0) :-
    unescape(I, U),
    (
        I = Selected -> format("~w: ~w ✔️ ~n", [N, U])
        ; format("~w: ~w~n", [N, U])
    ),
    M is N + 1,
    print_serialized_items(Items, Selected, M, Item0).

%! all_items(+Category, -Items)
% dynamically unifies all items under Category to Items
all_items(Category, Items) :- all_items(Category, [], Items).
all_items(Category, U, [I|Items]) :-
    call(Category, I),
    \+ member(I, U),
    !,
    all_items(Category, [I|U], Items).
all_items(_, _, []).


ordered_map_put(_, K, V, [], [], [K], [V]).
ordered_map_put([K|_], K, V, [K|Ks], [_|Vs], [K|Ks], [V|Vs]).
ordered_map_put([K|_], K, V, [K0|Ks], Vs, [K,K0|Ks], [V|Vs]) :- K \= K0.
ordered_map_put([K0|KOrder], K, V, [K0|Ks0], [V0|Vs0], [K0|Ks], [V0|Vs]) :- 
    K \= K0,
    ordered_map_put(KOrder, K, V, Ks0, Vs0, Ks, Vs).
ordered_map_put([K0|KOrder], K, V, [K1|Ks0], [V1|Vs0], [K1|Ks], [V1|Vs]) :- 
    K0 \= K1,
    ordered_map_put(KOrder, K, V, Ks0, Vs0, Ks, Vs).
%! ordered_map_put(+KOrder, +K, +V, +Ks0, +Vs0, -Ks, -Vs)
ordered_map_put(KOrder, K, V, Ks0, Vs0, Ks, Vs) :- fail.

map_get(K, [K|Ks], [V|Vs], V).
map_get(K, [K0|Ks], [_|Vs], V) :- 
    K \= K0,
    map_get(K, Ks, Vs, V).

map_unset(_, [], [], [], []).
map_unset(K, [K|Ks], [_|Vs], Ks, Vs).
map_unset(K, [K0|Ks0], [V|Vs0], [K0|Ks], [V|Vs]) :- 
    K \= K0,
    map_unset(K, Ks0, Vs0, Ks, Vs).
