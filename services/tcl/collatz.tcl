# One hailstone step from Tcl, whose event loop has served sockets since the nineties.
proc step {n} {
    expr {$n % 2 == 0 ? $n / 2 : 3 * $n + 1}
}

proc accept {chan addr port} {
    fconfigure $chan -translation {auto crlf}
    gets $chan request
    while {[gets $chan header] > 0} {}

    # scan, because Tcl 8 would read 010 as octal.
    if {[regexp {[?&]n=([0-9]+)[ &]} $request -> digits] && [scan $digits %d n] == 1 && $n > 0} {
        set status "200 OK"
        set body [step $n]
    } else {
        set status "400 Bad Request"
        set body "need ?n=<positive integer>"
    }
    puts -nonewline $chan "HTTP/1.0 $status\nContent-Type: text/plain\nContent-Length: [string length $body]\n\n$body"
    close $chan
}

socket -server accept 8000
puts "Tcl is listening on :8000"
vwait forever
