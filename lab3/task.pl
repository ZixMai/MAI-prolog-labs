bad(volk, koza).
bad(koza, volk).
bad(kapusta, koza).
bad(koza, kapusta).

checkIfBad([E1, E2]) :- bad(E1, E2).

push_back(E, [], [E]).
push_back(E, [H|T], [H|T1]) :- push_back(E, T, T1).

print_list([]).
print_list([A|T]) :- print_list(T), write(A), nl.

move(s([E1, E2, E3], 'L', []), s([E1, E2], 'R', [E3])) :- not(checkIfBad([E1, E2])).
move(s([E1, E2, E3], 'L', []), s([E1, E3], 'R', [E2])) :- not(checkIfBad([E1, E3])).
move(s([E1, E2, E3], 'L', []), s([E2, E3], 'R', [E1])) :- not(checkIfBad([E2, E3])).

move(s([L|T], 'R', R), s([L|T], 'L', R)) :- not(checkIfBad(R)).
move(s(L, 'R', [E1, E2]), s(RES, 'L', [E2])) :- checkIfBad([E1, E2]), push_back(E1, L, RES).

move(s([L|LT], 'L', [R|RT]), s(LT, 'R', RES)) :- push_back(L, [R|RT], RES).
move(s([X, L|LT],'L',[R|RT]), s([X|LT], 'R', RES)) :- push_back(L, [R|RT], RES).

prolong([In1|In2], [RES, In1|In2]) :- move(In1, RES), not(member(RES, [In1|In2])).

depth([X|T], X, [X|T]).
depth(P, F, L) :- prolong(P, P1), depth(P1, F, L).

breadth([[A|T]|_], A, [A|T]).
breadth([H|T1], X, R) :- findall(Z, prolong(H, Z), T), append(T1, T, RES), !, breadth(RES, X, R).
breadth([_|T], X, R) :- breadth(T, X, R).

depthIter([F|T], F, [F|T], 0).
depthIter(Path, F, R, N) :- N > 0, prolong(Path, Path1), N1 is N - 1, depthIter(Path1, F, R, N1).

% DFS
searchDFS(X, Y) :-
    get_time(DFSstart),
    depth([X], Y, L),
    print_list(L),
    get_time(DFSend),
    DFStime is DFSend - DFSstart,
    format('Time spent ~w~n========================================~n', [DFStime]).

% BFS
searchBFS(X, Y) :-
    get_time(BFSstart),
    breadth([[X]], Y, L),
    print_list(L),
    get_time(BFSend),
    BFStime is BFSend - BFSstart,
    format('Time spent ~w~n========================================~n', [BFStime]).

% Iterative
searchIter(S, F) :-
    get_time(ITERstart),
    between(1, 100, DepthLimit),
    depthIter([S], F, Res, DepthLimit),
    print_list(Res),
    get_time(ITERend),
    ITERtime is ITERend - ITERstart,
    format('Time spent ~w~n========================================~n', [ITERtime]).

search :-
    write('========================================'), nl,
    get_time(T1),
    findall(_, searchDFS(s([volk, koza, kapusta], 'L', []), s([], 'R', [_,_,_])), _),
    get_time(T2),
    DFStotalTime is T2 - T1,

    get_time(T3),
    findall(_, searchBFS(s([volk, koza, kapusta], 'L', []), s([], 'R', [_,_,_])), _),
    get_time(T4),
    BFStotalTime is T4 - T3,
    get_time(T5),
    findall(_, searchIter(s([volk, koza, kapusta], 'L', []), s([], 'R', [_,_,_])), _),
    get_time(T6),
    ITERtotalTime is T6 - T5,
    format('Total DFS Time: ~w~n========================================~n', [DFStotalTime]),
    format('Total BFS Time: ~w~n========================================~n', [BFStotalTime]),
    format('Total iterative Time: ~w~n========================================~n', [ITERtotalTime]).