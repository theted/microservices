% One hailstone step in Prolog. step/2 is a relation between N and Next.
step(N, Next) :- N mod 2 =:= 0, !, Next is N // 2.
step(N, Next) :- Next is 3 * N + 1.

:- initialization(main, main).

main :-
    read_line_to_string(user_input, Line),
    number_string(N, Line),
    step(N, Next),
    format("~w~n", [Next]).
