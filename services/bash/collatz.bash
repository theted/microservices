#!/usr/bin/env bash
# A real bash web server: no socat, no netcat. bash-builtins ships an accept
# builtin that listens on a port, takes one connection and hands over its fd.
enable -f /usr/lib/bash/accept accept || exit 1

query='[?&]n=([0-9]+)(&|$)'
echo "Bash is listening on :8000"

while accept -v fd 8000; do
    read -r -u "$fd" _method target _version
    while read -r -u "$fd" header && [[ $header != $'\r' && -n $header ]]; do :; done

    # 10# because bash would read 010 as octal.
    if [[ $target =~ $query ]] && ((10#${BASH_REMATCH[1]} > 0)); then
        n=$((10#${BASH_REMATCH[1]}))
        status="200 OK" body=$((n % 2 ? 3 * n + 1 : n / 2))
    else
        status="400 Bad Request" body="need ?n=<positive integer>"
    fi

    printf 'HTTP/1.0 %s\r\nContent-Type: text/plain\r\nContent-Length: %d\r\n\r\n%s' \
        "$status" "${#body}" "$body" >&"$fd"
    exec {fd}>&-
done
