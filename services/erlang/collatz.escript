%% One hailstone step in Erlang.
step(N) when N rem 2 =:= 0 -> N div 2;
step(N) -> 3 * N + 1.

main(_) ->
    {ok, [N]} = io:fread("", "~d"),
    io:format("~b~n", [step(N)]).
