%% -----------------
%% Relationship Data
%% -----------------
parent(jatin,avantika).
parent(jolly,jatin).
parent(jolly,kattappa).
parent(manisha,avantika).
parent(manisha,shivkami).
parent(bahubali,shivkami).

%% -----------
%% Gender data
%% -----------
male(jatin).
male(kattappa).
male(jolly).
male(bahubali).
female(manisha).
female(shivkami).
female(avantika).

%% ----------------------------------------
%% Rules for determining Uncle Relationship
%% ----------------------------------------
grand_parent(X, Y) :-
    parent(X, Z), parent(Z, Y).

uncle(X, Y) :-
    male(X),
    grand_parent(Z, Y), parent(Z, X),
    \+ parent(X, Y).

%% ----------------------------------------------
%% Rules for determining Half-Sister Relationship
%% ----------------------------------------------
half_sister(X, Y) :-
    X \== Y,
    female(X),
    parent(A, X), parent(A, Y),     
    parent(C, X), parent(D, Y),
    A \== C,
    A \== D,
    C \== D.
