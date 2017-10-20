%% Setting prolog flag to display large lists
:- set_prolog_flag(answer_write_options,[max_depth(0)]).
maze(6, 6).
start([1, 1]).
start([3, 1]).
start([5, 1]).
end([2, 6]).
end([4, 6]).
end([6, 6]).
barrier([1,2], [1,3]).
barrier([2,2], [2,3]).
barrier([4,2], [4,3]).
barrier([5,2], [5,3]).
barrier([3,4], [3,5]).
barrier([5,4], [5,5]).
barrier([4,5], [4,6]).
barrier([2,3], [3,3]).
barrier([2,4], [3,4]).
barrier([3,2], [4,2]).
barrier([3,3], [4,3]).
barrier([3,6], [4,6]).
barrier([4,5], [5,5]).
barrier([5,3], [6,3]).
barrier([5,4], [6,4]).

inside_maze(X, Y) :-
    maze(M, N),
    X =< M,
    Y =< N,
    X >= 1,
    Y >= 1.

adjacent([X, Y1], [X, Y2]) :-
    Y2 is Y1 - 1.    

adjacent([X, Y1], [X, Y2]) :-
    Y2 is Y1 + 1.    

adjacent([X1, Y], [X2, Y]) :-
    X2 is X1 - 1.    

adjacent([X1, Y], [X2, Y]) :-
    X2 is X1 + 1.    

valid_move([X1, Y1], [X2, Y2]) :-
    adjacent([X1, Y1], [X2, Y2]),
    inside_maze(X2, Y2),
    not(barrier([X1, Y1], [X2, Y2])),
    not(barrier([X2, Y2], [X1, Y1])).

solve_maze_helper(Start, Start, _, Path, Path) :-
    !.
solve_maze_helper(Start, Current, MaxL, Acc, Path) :-
    length(Acc, Len),
    Len =< MaxL,
    valid_move(Current, Next),
    not(memberchk(Next, Acc)),
    solve_maze_helper(Start, Next, MaxL, [Next|Acc], Path).
solve_maze(L) :-
    start(Start),
    end(End),
    maze(N, M),
    solve_maze_helper(Start, End, N*M, [End], L).

find_shortest_path([], _, MinPath, MinPath).
find_shortest_path([Path|Paths], MinLen, _, Output) :-
    length(Path, N),
    N < MinLen,
    find_shortest_path(Paths, N, Path, Output).
find_shortest_path([Path|Paths], MinLen, MinPath, Output) :-
    length(Path, N),
    N >= MinLen,
    find_shortest_path(Paths, MinLen, MinPath, Output).

solve_maze_shortest(L) :-
    solve_maze_shortest(_, _, L, _).
solve_maze_shortest(Start, End, L, Count) :-
    start(Start),
    end(End),
    maze(N, M),
    findall(Path, solve_maze_helper(Start, End, N*M, [End], Path), Paths),
    find_shortest_path(Paths, N*M, [], L),
    length(Paths, Count).
