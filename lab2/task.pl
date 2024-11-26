statement('Andrey', Guilty):-
    Guilty = 'Vitya'; Guilty = 'Tolya'.

statement('Vitya', Guilty):-
    Guilty \= 'Vitya', Guilty \= 'Yura'.

statement('Dima', Guilty):-
    (statement('Andrey', Guilty), not(statement('Vitya', Guilty)));
    (statement('Vitya', Guilty), not(statement('Andrey', Guilty))).

statement('Yura', Guilty):-
    not(statement('Dima', Guilty)).

speakers(['Andrey', 'Vitya', 'Dima', 'Yura']).

members(['Andrey', 'Vitya', 'Dima', 'Yura', 'Tolya']).

is_statement_true([], _).
is_statement_true([H|T], Guilty):-
   statement(H, Guilty),
   is_statement_true(T, Guilty).

solve(Guilty):-
    members(Member), member(Guilty, Member),
    speakers(Speaker), member(Liar, Speaker),
    delete(Speaker, Liar, List),
    (is_statement_true(List, Guilty), not(statement(Liar, Guilty)));
    speakers(Speaker), is_statement_true(Speaker, Guilty).

solve(Guilty):-
    members(Member), member(Guilty, Member),
    speakers(Speaker), member(Liar, Speaker),
    delete(Speaker, Liar, List),
    is_statement_true(List, Guilty);
    speakers(Speaker), is_statement_true(Speaker, Guilty).