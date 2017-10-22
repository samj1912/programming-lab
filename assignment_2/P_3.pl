%% Setting prolog flag to display large lists
:- set_prolog_flag(answer_write_options,[max_depth(0)]).

%% ---------------
%% Maze Definition
%% ---------------

%% Maze size
maze(6, 6).

%% Maze start and end points in 2D co-ordinates with the
%% top-left point being [1, 1] and bottom right being [N, M]
%% for maze(N, M)
start([1, 1]).
start([3, 1]).
start([5, 1]).
end([2, 6]).
end([4, 6]).
end([6, 6]).

%% Maze barriers.
%% A barrier between [X0, Y0] and [X1, Y1]
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

%% ================== 
%% Maze Solving rules
%% ==================

%% ----------------- 
%% Utility functions 
%% ----------------- 

%% Function to determine if a point [X, Y] is a
%% point inside the maze or not
inside_maze(X, Y) :-
    maze(N, M),
    X =< M,
    Y =< N,
    X >= 1,
    Y >= 1.

%% Functions to calculate points adjacent to [X1, Y1] 
adjacent([X, Y1], [X, Y2]) :-
    Y2 is Y1 - 1.    

adjacent([X, Y1], [X, Y2]) :-
    Y2 is Y1 + 1.    

adjacent([X1, Y], [X2, Y]) :-
    X2 is X1 - 1.    

adjacent([X1, Y], [X2, Y]) :-
    X2 is X1 + 1.    

%% Function to determine a valid move from [X1, Y1]
%% i.e. a move to an adjacent point which does not cross a barrier
valid_move([X1, Y1], [X2, Y2]) :-
    adjacent([X1, Y1], [X2, Y2]),
    inside_maze(X2, Y2),
    not(barrier([X1, Y1], [X2, Y2])),
    not(barrier([X2, Y2], [X1, Y1])).

%% ---------------------- 
%% Maze Solving Algorithm
%% ----------------------

%% We are building the path from the End point to the start
%% point as it is more efficient to append points to a path that way.

%% Recursion base case to return the final path once
%% we reach the start point from the end point. 
solve_maze_helper(Start, Start, _, Path, Path) :-
    !.

%% Backtracking function to consider all valid moves to reach
%% `Start` from `Current` returning a `Path` of max length `MaxL`
%% using an accumalator `Acc` 
solve_maze_helper(Start, Current, MaxL, Acc, Path) :-
    length(Acc, Len),
    Len =< MaxL,
    valid_move(Current, Next),
    not(memberchk(Next, Acc)),
    solve_maze_helper(Start, Next, MaxL, [Next|Acc], Path).

%% Function to initialize the maze solving algorithm 
solve_maze(L) :-
    start(Start),
    end(End),
    maze(N, M),
    solve_maze_helper(Start, End, N*M, [End], L).

%% ------------------------------
%% Optimal Maze Solving Algorithm
%% ------------------------------

%% Optimal path finding algorithm, the Optimal path being the one with 
%% the least number of hops. We are basically finding all the possible paths
%% between a pair of Start and End points and picking the one with the shortest length.

%% Recursion base case to return the shortest path when
%% the list of Paths becomes empty
find_shortest_path([], _, MinPath, MinPath).

%% Recursion case when the current path is shorter than the 
%% current minimum. We update the accumalators `MinPath` and `MinLen`
%% with the new values respectively.
find_shortest_path([Path|Paths], MinLen, _, Output) :-
    length(Path, N),
    N < MinLen,
    find_shortest_path(Paths, N, Path, Output).

%% Recursion case when the current path is longer than the current
%% minimum. We just continue the call with the next path on the path list.
find_shortest_path([Path|Paths], MinLen, MinPath, Output) :-
    length(Path, N),
    N >= MinLen,
    find_shortest_path(Paths, MinLen, MinPath, Output).

%% A simple display function to display all optimal paths.
solve_maze_shortest(L) :-
    solve_maze_shortest(_, _, L, _, _).

%% Utility function to initialize the Optimal Maze solver
%% with appropriate values for `Start` point, `End` point, 
%% initial minimum length (size of the maze) and a list of all paths, `Paths`
solve_maze_shortest(Start, End, L, Count, PathLength) :-
    start(Start),
    end(End),
    maze(N, M),
    findall(Path, solve_maze_helper(Start, End, N*M, [End], Path), Paths),
    find_shortest_path(Paths, N*M, [], L),
    length(L, PathLength),
    length(Paths, Count).
