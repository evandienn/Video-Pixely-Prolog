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
        unescape_format/2,
        print_serialized_items/1,
        print_serialized_items/2,
        print_serialized_items/3,
        print_serialized_items/4,
        all_items/2,
        ordered_map_put/7,
        map_get/4,
        map_unset/5,
        heads_only/2
    ]).
:- use_module(facts).

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
unescape_list([], []).
unescape_list([is_list(Arg)|Args], [UArg|UArgs]) :-
    unescape_list(Arg, UArg),
    unescape_list(Args, UArgs).
unescape_list([Arg|Args], [UArg|UArgs]) :-
    unescape(Arg, UArg),
    unescape_list(Args, UArgs).
unescape_format(Format, Args) :-
    unescape_list(Args, UArgs),
    format(Format, UArgs).

print_with_category_items(Prefix, [], []) :-
    write(Prefix).
%! print_with_category_items(+Prefix, +Categories, +Answers)
%
%  pretty prints the given category items
print_with_category_items(Prefix, Categories, Answers) :-
    write(Prefix), write(" when "),
    print_with_category_items(Categories, Answers).
print_with_category_items([C/_], [A]) :-
    display_format(C, Format),
    format(string(Formatted), Format, A),
    unescape_format("the ~w is ~w", [C, Formatted]).
print_with_category_items([C1/_, C2/_], [A1, A2]) :-
    display_format(C1, Format1),
    format(string(Formatted1), Format1, A1),
    display_format(C2, Format2),
    format(string(Formatted2), Format2, A2),
    unescape_format("the ~w is ~w and the ~w is ~w", [C1,Formatted1,C2,Formatted2]).
print_with_category_items([C/_|Categories], [A|Answers]) :-
    display_format(C, Format),
    format(string(Formatted), Format, A),
    unescape_format("the ~w is ~w, ", [C, Formatted]),
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
    print_serialized_items(Items, Selected, Item0, "~w").
print_serialized_items(Items, Selected, Item0, Format0) :-
    string_concat("~w: ", Format0, Format),
    print_serialized_items(Items, Selected, Item0, Format, 1).
print_serialized_items([], _, none, _, _).
print_serialized_items([], _, Item0, _, _) :-
    Item0 \= none,
    format("0: ~w~n", [Item0]).
print_serialized_items([I|Items], Selected, Item0, Format, N) :-
    \+ is_list(I),
    print_serialized_items([[I]|Items], Selected, Item0, Format, N).
print_serialized_items([I|Items], Selected, Item0, Format, N) :-
    unescape_format(Format, [N|I]),
    (
        I = Selected -> write(" ✔️ "), nl
        ; nl
    ),
    M is N + 1,
    print_serialized_items(Items, Selected, Item0, Format, M).

%! all_items(+Category, -Items)
% dynamically unifies all items under Category to Items
all_items(Category/N, Items) :- all_items(Category/N, [], Items).
all_items(Category/N, U, [I|Items]) :-
    goal_n_arity(Category/N, I, Goal),
    call(Goal),
    \+ member(I, U),
    !,
    all_items(Category/N, [I|U], Items).
all_items(_, _, []).

heads_only([], []).
heads_only([[H|_]|List], [H|Heads]) :-
    heads_only(List, Heads).

goal_n_arity(Category/N, Terms, Goal) :-
    n_arity(N, Terms),
    Goal =.. [Category|Terms].
n_arity(0, []).
n_arity(N, [_|Terms]) :-
    N > 0,
    M is N - 1,
    n_arity(M, Terms).

ordered_map_put(_, K, V, [], [], [K], [V]).
ordered_map_put(KOdrs, K, V, Ks0, Vs0, Ks, Vs) :-
    (
        nth0(Index, Ks0, K) ->
            Ks = Ks0,
            nth0(Index, Vs0, _, R),
            nth0(Index, Vs, V, R)
        ; preceding_list(KOdrs, K, Ks0) ->
            Ks = [K|Ks0],
            Vs = [V|Vs0]
        ; following_list(KOdrs, Ks0, K) ->
            append(Ks0, [K], Ks),
            append(Vs0, [V], Vs)
        ; insert_into_list(KOdrs, Ks0, Vs0, K, V, Ks, Vs)
    ).
preceding_list(KOdrs, K, [K0|_]) :-
    nth0(Idx0, KOdrs, K0),
    nth0(IdxK, KOdrs, K),
    IdxK < Idx0.

insert_into_list([K|_], [OK|OKs], OVs, K, V, [K,OK|OKs], [V|OVs]) :-
    OK \= K.
insert_into_list([OK|KOdrs], [OK|OKs], [OV|OVs], K, V, [OK|Ks], [OV|Vs]) :-
    OK \= K,
    insert_into_list(KOdrs, OKs, OVs, K, V, Ks, Vs).
insert_into_list([KOdr|KOdrs], [OK|OKs], OVs, K, V, Ks, Vs) :-
    KOdr \= K,
    OK \= K,
    insert_into_list(KOdrs, [OK|OKs], OVs, K, V, Ks, Vs).

following_list(KOdrs, [K0], K) :-
    nth0(Idx0, KOdrs, K0),
    nth0(IdxK, KOdrs, K),
    IdxK > Idx0.
following_list(KOrds, [_|Ks0], K) :-
    following_list(KOrds, Ks0, K).

map_get(K, [K|_], [V|_], V).
map_get(K, [K0|Ks], [_|Vs], V) :-
    K \= K0,
    map_get(K, Ks, Vs, V).

map_unset(_, [], [], [], []).
map_unset(K, [K|Ks], [_|Vs], Ks, Vs).
map_unset(K, [K0|Ks0], [V|Vs0], [K0|Ks], [V|Vs]) :-
    K \= K0,
    map_unset(K, Ks0, Vs0, Ks, Vs).
