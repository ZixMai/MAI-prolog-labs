location_word('тут', loc).
location_word('там', loc).
location_word('здесь', loc).
location_word('поблизости', loc).

object_word('Даша', agent).

object_word('шоколад', object).
object_word('деньги', object).

action_verb('любить', ['любить', 'любит', 'любима']).
action_verb('лежать', ['лежать', 'лежит', 'лежат']).
action_verb('хотеть', ['хочешь', 'хотите', 'хотят']).

question_word('Кто', agent).
question_word('Кому', agent).
question_word('Кого', agent).
question_word('Чей', agent).

question_word('Что', object).
question_word('Чего', object).
question_word('Чему', object).

question_word('Где', loc).

concatenate_strings(ListOfStrings, ResultString) :-
    findall(Chars, (member(String, ListOfStrings), atom_chars(String, Chars)), CharsLists),
    append(CharsLists, AllChars),
    atom_chars(ResultString, AllChars).

find_action_verb(Form, Verb) :-
    action_verb(Verb, VerbsList),
    member(Form, VerbsList).

generate_verb(agent, SType, Subject, Action, Result) :-
    build_action_sentence(Action, agent, 'X', SType, Subject, Result).
generate_verb(object, SType, Subject, Action, Result) :-
    build_action_sentence(Action, SType, Subject, object, 'X', Result).
generate_verb(loc, SType, Subject, Action, Result) :-
    build_action_sentence(Action, SType, Subject, loc, 'X', Result).

build_action_sentence(Verb, MainPredicate, MainArg, SecondPredicate, SecondArg, Result) :-
    concatenate_strings([Verb, '(', MainPredicate, '(', MainArg, '), ', SecondPredicate, '(', SecondArg, ')', ')'], Result).

an_q([QuestionWord, Action, Subject, '?'], Result) :-
    find_action_verb(Action, NormalizedAction),
    question_word(QuestionWord, QueryType),
    object_word(Subject, SubjectType),
    generate_verb(QueryType, SubjectType, Subject, NormalizedAction, Result).
