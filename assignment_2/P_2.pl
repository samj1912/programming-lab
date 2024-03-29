%% ---------------
%% Table 1 details
%% ---------------

%% detail1([Roll Number, Name, Email, Type])
detail1([1, 'Sambhav Kothari', 'sam@iitg.ac.in', 'Regular']).
detail1([2, 'Gaurav Manchanda', 'gau@iitg.ac.in', 'Regular']).
detail1([3, 'Shivam Goyal', 'shi@iitg.ac.in', 'Regular']).
detail1([4, 'Abhisek', 'abh@iitg.ac.in', 'Part-time']).
detail1([5, 'Hemant Verma', 'hem@iitg.ac.in', 'QIP']).
detail1([6, 'Chhavi Shrivastava', 'chh@iitg.ac.in', 'Regular']).
detail1([7, 'Laurent Monin', 'lau@iitg.ac.in', 'Foreign']).
detail1([8, 'Robert Kaye', 'rob@iitg.ac.in', 'QIP']).
detail1([9, 'Nicolas Tam', 'nic@iitg.ac.in', 'Regular']).
detail1([10, 'Elizabeth Bigger', 'eli@iitg.ac.in', 'Regular']).

%% ---------------
%% Table 2 details
%% ---------------

%% detail2([Roll Number, Name, Type, Supervisor, Co-Supervisor(Nullable)])
detail2([1, 'Sambhav Kothari', 'Regular', 'Samit B.']).
detail2([2, 'Gaurav Manchanda', 'Regular', 'Samit B.', 'Amit A.']).
detail2([3, 'Shivam Goyal', 'Regular', 'Samit B.']).
detail2([4, 'Abhisek', 'Part-time', 'Samit B.', 'Amit A.']).
detail2([5, 'Hemant Verma', 'QIP', 'Samit B.']).
detail2([6, 'Chhavi Shrivastava', 'Regular', 'Samit B.', 'Amit A.']).
detail2([7, 'Laurent Monin', 'Foreign', 'Samit B.']).
detail2([8, 'Robert Kaye', 'QIP', 'Samit B.']).
detail2([9, 'Nicolas Tam', 'Regular', 'Samit B.', 'Amit A.']).
detail2([10, 'Elizabeth Bigger', 'Regular', 'Samit B.']).

%% ----------------------------
%% Rules for finding and search
%% ----------------------------

%% Joins the 2 tables. It has 2 definitions to take care
%% of the cases when Cosup is absent from data.
join(detail1([Roll_no, Name, Email, Type]),
     detail2([Roll_no, Name, Type, Sup]),
     [Roll_no, Name, Email, Sup, Type]).
join(detail1([Roll_no, Name, Email, Type]),
     detail2([Roll_no, Name, Type, Sup, Cosup]),
     [Roll_no, Name, Email, Sup, Cosup, Type]).

%% Search functions to search by roll number and name 
search_by_roll(I, L) :- 
    detail1([I | La]),
    detail2([I | Lb]),
    join(detail1([I | La]), detail2([I | Lb]), L).
search_by_name(N, L) :-
    detail1([I, N | La]), detail2([I, N | Lb]), join(detail1([I, N | La]), detail2([I, N | Lb]), L).

%% Unified search
search(A, L) :-
    search_by_name(A, L);
    search_by_roll(A, L).

%% Display joined details of all students
display(L) :-
    search_by_roll(_, L).