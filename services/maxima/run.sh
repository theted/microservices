#!/bin/sh
# Maxima has no simple way to read stdin, so n is set before the file loads.
exec maxima --very-quiet -r "n: $N\$ batchload(\"/app/collatz.mac\")\$"
