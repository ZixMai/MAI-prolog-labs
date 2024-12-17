/*
9. Реализовать разбор фраз языка (вопросов), выделяя в них неизвестный объекты
………………………………………………………………………………………………
Запрос:
?- an_q([“Кто”, “любит”, “шоколад” “?”],X)
?- an_q([“Где”, “лежат”, “деньги” “?”],X)
?- an_q([“Что”, “любит”, “Даша” “?”],X)
Результат:
X=’любить’(agent(Y), object(’шоколад’)),
X=’лежать’(object(‘деньги’), loc(X)),
X=’любить’(agent(“Даша”), object(Y)).
*/
% agent - кто?
% object - что?
% loc - где?

% Строка - Вопросное_Слово Действие Объект/Агент/Место/Время '?'

find_action_verb(Form, Verb) :-
    action_verb(Verb, VerbsList),
    member(Form, VerbsList).

location_word('тут', loc).
location_word('там', loc).
location_word('здесь', loc).
location_word('поблизости', loc).

person_word('Даша', agent).

object_word('шоколад', object).
object_word('деньги', object).

concatenate_strings(ListOfStrings, ResultString) :-
    findall(Chars, (member(String, ListOfStrings), atom_chars(String, Chars)), CharsLists),
    append(CharsLists, AllChars),
    atom_chars(ResultString, AllChars).

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
