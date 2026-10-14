#!/usr/bin/env escript
%% One hailstone step from Erlang, which has run telephone switches since 1986.
%% With {packet, http_bin}, gen_tcp parses the HTTP request for us.
-mode(compile).

step(N) when N rem 2 =:= 0 -> N div 2;
step(N) -> 3 * N + 1.

main(_) ->
    {ok, Listener} = gen_tcp:listen(8000, [binary, {packet, http_bin}, {active, false}, {reuseaddr, true}]),
    io:format("Erlang is listening on :8000~n"),
    accept(Listener).

accept(Listener) ->
    {ok, Socket} = gen_tcp:accept(Listener),
    Pid = spawn(fun() -> receive go -> handle(Socket) end end),
    ok = gen_tcp:controlling_process(Socket, Pid),
    Pid ! go,
    accept(Listener).

handle(Socket) ->
    {Status, Body} =
        case gen_tcp:recv(Socket, 0) of
            {ok, {http_request, 'GET', {abs_path, Path}, _Version}} ->
                skip_headers(Socket),
                answer(Path);
            _ ->
                bad_request()
        end,
    gen_tcp:send(Socket, [<<"HTTP/1.0 ">>, Status,
                          <<"\r\nContent-Type: text/plain\r\nContent-Length: ">>,
                          integer_to_binary(byte_size(Body)), <<"\r\n\r\n">>, Body]),
    gen_tcp:close(Socket).

answer(Path) ->
    case re:run(Path, <<"[?&]n=([0-9]+)(&|$)">>, [{capture, [1], binary}]) of
        {match, [Digits]} ->
            case binary_to_integer(Digits) of
                N when N > 0 -> {<<"200 OK">>, integer_to_binary(step(N))};
                _ -> bad_request()
            end;
        nomatch ->
            bad_request()
    end.

bad_request() -> {<<"400 Bad Request">>, <<"need ?n=<positive integer>">>}.

skip_headers(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, {http_header, _, _, _, _}} -> skip_headers(Socket);
        _ -> ok
    end.
