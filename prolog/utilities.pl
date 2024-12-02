:- module(utilities,
    [
        graceful_call/2,
        zip/3,
        unzip/3,
        all_strict_sublists/2,
        unescape/2,
        escape/2,
        read_str/1,
        read_number/2,
        get_yes_or_no/1,
        print_with_category_items/3
    ]).

graceful_call(Goal, A) :- catch(call(Goal, A), _, fail).

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

read_number(_, No) :-
    read_str(Input),
    atom_number(Input, No).
read_number(Question, No) :-
    write(Question),
    read_number(Question, No).

get_yes_or_no(YesOrNo) :-
    read_str(YN),
    string_lower(YN, LYN),
    (
      LYN = "yes" -> YesOrNo = yes
    ; LYN = "no" -> YesOrNo = no
    ; write("Please enter yes or no."), nl, get_yes_or_no(YesOrNo)
    ).

% Pretty-prints the given category items
print_with_category_items(Prefix, [], []) :- write(Prefix).
print_with_category_items(Prefix, Categories, Answers) :-
    write(Prefix), write(" when "),
    print_with_category_items(Categories, Answers).
print_with_category_items([C], [A]) :-
    format("the ~w is ~w", [C, A]).
print_with_category_items([C1, C2], [A1, A2]) :-
    format("the ~w is ~w and the ~w is ~w", [C1, A1, C2, A2]).
print_with_category_items([C|Categories], [A|Answers]) :-
    format("the ~w is ~w, ", [C, A]),
    print_with_category_items(Categories, Answers).
