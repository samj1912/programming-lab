parent(jatin,avantika).
parent(jolly,jatin).
parent(jolly,kattappa).
parent(manisha,avantika).
parent(manisha,shivkami).
parent(bahubali,shivkami).
male(kattappa).
male(jolly).
male(bahubali).
female(shivkami).
female(avantika).
grandparent(X, Y) :-
    parent(X, Z), parent(Z, Y).
uncle(X, Y) :-
    male(X), grandparent(Z, Y), parent(Z, X), \+parent(X,Y).
halfsister(X, Y) :-
    X \== Y,
    female(X),
    parent(A, X), parent(A, Y),     
    parent(C, X), parent(D, Y),
    A \== C,
    A \== D,
    C \== D. 
