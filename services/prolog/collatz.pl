:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).

:- http_handler(root(.), collatz, []).

%!  step(+N, -Next) is det.
step(N, Next) :- N mod 2 =:= 0, !, Next is N // 2.
step(N, Next) :- Next is 3 * N + 1.

collatz(Request) :-
    http_parameters(Request, [n(N, [between(1, inf)])]),
    step(N, Next),
    format("Content-type: text/plain~n~n~w", [Next]).

main :-
    http_server(http_dispatch, [port(8000)]),
    format(user_error, "Prolog is listening on :8000~n", []),
    thread_get_message(_).

:- initialization(main, main).
