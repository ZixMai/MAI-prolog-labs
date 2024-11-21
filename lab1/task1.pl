permute([], []).
permute(L, [X|T]):- remove(X,L,R), permute(R, T).

sublist1(S, L) :- append1(_, L1, L), append1(S, _, L1).

member1(A, [A|_]).
member1(A, [_|Z]) :- member1(A,Z).

remove(X, [X|T], T).
remove(X, [Y|T], [Y|T1]) :- remove(X,T,T1).

length1([], 0).
length1([_|Y], N) :- length1(Y, N1), N is N1 + 1.

append1([], X, X).
append1([A|X], Y, [A|Z]) :- append1(X,Y,Z).

remove_n(L,X,N) :- append1(_, X, L), length1(X, N).

get_first([], _) :- fail.
get_first([A|_], A1) :- A1 is A.



get_element_n_1([], _, -1) :- fail.
get_element_n_1([E|_], 0, E).
get_element_n_1([_|X], N, R) :- N > 0, N1 is N - 1, get_element_n_1(X, N1, R).

get_element_n_2([], _, -1) :- fail.
get_element_n_2([E|_], 0, E).
get_element_n_2(L, N, X) :- length1(L, C), N1 is C - N, remove_n(L, R, N1), get_first(R, X).



check_geoprog_with_coefficient([_], _).
check_geoprog_with_coefficient([N1, N2|L], K) :- K =:= N2/N1, check_geoprog_with_coefficient([N2|L], N2/N1).

check_geoprog([]).
check_geoprog([_]).
check_geoprog([N1, N2|L]) :- K is N2/N1, check_geoprog_with_coefficient([N2|L], K).



check_geoprog_with_coefficient_2([_], [_]).
check_geoprog_with_coefficient_2([N1, N2|L], M) :- K is N2/N1, member1(K, M), remove(N1, [N1, N2|L], L1), check_geoprog_with_coefficient_2(L1, M).

check_geoprog2([]).
check_geoprog2([_]).
check_geoprog2([N1, N2|L]) :- K is N2/N1, check_geoprog_with_coefficient_2([N2|L], [K]).
