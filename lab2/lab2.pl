:- encoding(utf8).
Максимальныйпупсик(X, Y, X) :- X >= Y.
Максимальныйпупсик(X, Y, Y) :- Y > X.
