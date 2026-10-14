#!/usr/bin/gawk -f
# gawk is its own web server: opening the special file /inet/tcp/8000/0/0
# listens on port 8000 and accepts one connection. Close it and loop for the next.
BEGIN {
    http = "/inet/tcp/8000/0/0"
    print "gawk is listening on :8000" > "/dev/stderr"
    while (1) {
        status = "400 Bad Request"
        body = "need ?n=<positive integer>"
        if ((http |& getline request) > 0 && match(request, /[?&]n=([0-9]+)[ &]/, m) && (n = m[1] + 0) > 0) {
            status = "200 OK"
            body = n % 2 ? 3 * n + 1 : n / 2
        }
        # Lines keep their \r. Don't "fix" that with RS = "\r?\n": a regex RS makes
        # gawk read ahead for more input, and the client is waiting for us to answer.
        while ((http |& getline header) > 0 && header != "\r" && header != "")
            ;
        printf "HTTP/1.0 %s\r\nContent-Type: text/plain\r\nContent-Length: %d\r\n\r\n%s", status, length(body), body |& http
        close(http)
    }
}
