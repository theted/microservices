#!/bin/sh
# One HTTP request in (socat hands us the socket as stdin/stdout), one run of
# $STEP_CMD out. The program gets n on stdin and as $N; whatever it prints,
# the last integer is the answer.

CR=$(printf '\r')

respond() { # <status> <body>
    printf 'HTTP/1.0 %s\r\nContent-Type: text/plain\r\nContent-Length: %s\r\nConnection: close\r\n\r\n%s' \
        "$1" "${#2}" "$2"
    exit 0
}

read -r _method target _version
# Drain the headers so closing the socket never resets the connection.
while read -r header; do
    case $header in '' | "$CR") break ;; esac
done

query=${target#*\?}
[ "$query" = "$target" ] && query=
n=
IFS='&'
for pair in $query; do
    case $pair in n=*) n=${pair#n=} ;; esac
done
unset IFS

# Leading zeros would turn 010 into octal in more than one language here.
while [ "${n#0}" != "$n" ]; do n=${n#0}; done
case $n in
    '' | *[!0-9]* | ???????????*) respond '400 Bad Request' 'need ?n=<positive integer>' ;;
esac

out=$(printf '%s\n' "$n" | N=$n timeout "${STEP_TIMEOUT:-10}" sh -c "$STEP_CMD") ||
    respond '500 Internal Server Error' "$STEP_CMD failed"
answer=$(printf '%s\n' "$out" | grep -oE -- '-?[0-9]+' | tail -n 1)
[ -n "$answer" ] || respond '500 Internal Server Error' "no number in: $out"
respond '200 OK' "$answer"
