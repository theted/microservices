# One hailstone step from Julia, with nothing but the Sockets standard library.
using Sockets

step(n::Integer) = iseven(n) ? n ÷ 2 : 3n + 1

function handle(client)
    request = readline(client)
    while !isempty(readline(client)) end
    m = match(r"[?&]n=(\d+)[ &]", request)
    n = m === nothing ? 0 : something(tryparse(Int, m[1]), 0)
    status, body = n > 0 ? ("200 OK", string(step(n))) : ("400 Bad Request", "need ?n=<positive integer>")
    write(client, "HTTP/1.0 $status\r\nContent-Type: text/plain\r\nContent-Length: $(sizeof(body))\r\n\r\n$body")
    close(client)
end

server = listen(IPv4(0), 8000)
println("Julia is listening on :8000")
while true
    client = accept(server)
    @async try
        handle(client)
    catch error
        @warn "request failed" error
    end
end
