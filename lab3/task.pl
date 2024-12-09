exception('Koza', 'Volk').
exception('Koza', 'Kapusta').
exception('Volk', 'Koza').
exception('Kapusta', 'Koza').

write_list([]).
write_list([H|T]) :-
  format('~w~n', [H]),
  write_list(T).

push_back(E, [], [E]).
push_back(E, [H|T], [H|T1]) :- push_back(E, T, T1).

check([Item1, Item2]) :- exception(Item1, Item2).

move(s([Item1, Item2, Item3], 'L', []), s([Item1, Item2], 'R', [Item3])) :- not(check([Item1, Item2])).
move(s([Item1, Item2, Item3], 'L', []), s([Item1, Item3], 'R', [Item2])) :- not(check([Item1, Item3])).
move(s([Item1, Item2, Item3], 'L', []), s([Item2, Item3], 'R', [Item1])) :- not(check([Item2, Item3])).

move(s([Left|T], 'R', Right), s([Left|T], 'L', Right)) :- not(check(Right)).
move(s(Left, 'R', [Item1, Item2]), s(Out, 'L', [Item2])) :- check([Item1, Item2]), push_back(Item1, Left, Out).

move(s([L|LT], 'L', [R|RT]), s(LT, 'R', Out)) :- push_back(L, [R|RT], Out).
move(s([X, L|LT], 'L', [R|RT]), s([X|LT], 'R', Out)) :- push_back(L, [R|RT], Out).

prolong([In|InT], [Out, In|InT]) :- move(In, Out), not(member(Out, [In|InT])).

breadth([[B|T]|_], B, [B|T]).
breadth([H|QT], X, R) :-
    findall(Z, prolong(H, Z), T),
    append(QT, T, OutQ), !,
    breadth(OutQ, X, R).
breadth([_|T], X, R) :- breadth(T, X, R).

depth([X|T], X, [X|T]).
depth(P, F, L) :- prolong(P, P1), depth(P1, F, L).

depthIter([Finish|T], Finish, [Finish|T], 0).
depthIter(Path, Finish, R, N) :-
    N > 0,
    prolong(Path, NewPath),
    N1 is N - 1,
    depthIter(NewPath, Finish, R, N1).

searchDepth(A, B) :-
    get_time(DFSstart),
    format('~n========================================~nsearchDepth START AT ~w~n========================================~n', [DFSstart]),
    findall(
        List,
        (
            get_time(StartTime),
            depth([A], B, List),
            get_time(EndTime),
            write_list(List),
            format('----------------------------------------~nsearchDepth END AT ~w~n', [EndTime]),
            DFStime is EndTime - StartTime,
            format('TIME IS ~w~n========================================~n', [DFStime])
        ),
        _
    ).

searchBreadth(X, Y) :-
    get_time(DFSstart),
    format('~n========================================~nsearchDepth START AT ~w~n========================================~n', [DFSstart]),
    findall(
        List,
        (
            get_time(StartTime),
            breadth([[X]], Y, List),
            get_time(EndTime),
            write_list(List),
            format('----------------------------------------~nsearchDepth END AT ~w~n', [EndTime]),
            BFStime is EndTime - StartTime,
            format('TIME IS ~w~n========================================~n', [BFStime])
        ),
        _
    ).

searchIterDepth(Start, Finish) :-
    TotalTime is 0,
    get_time(ITERstart),
    format('~n========================================~nsearchId START AT ~w~n========================================~n', [ITERstart]),
    between(1, inf, DepthLimit),
    depthIter([Start], Finish, List, DepthLimit),
    write_list(List),
    get_time(ITERend),
    format('----------------------------------------~nsearchId END AT ~w~n', [ITERend]),
    T3 is ITERend - ITERstart,
    format('TIME IS ~w~n========================================~n', [T3]),
    TotalTime is TotalTime + T3,
    write(TotalTime),
    get_time(ITERstart).

