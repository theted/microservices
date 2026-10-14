#!/bin/sh
# TeX insists on a log file and a chatty banner: give it a scratch dir and
# keep only the line we asked it to write.
dir=$(mktemp -d) && cd "$dir" || exit 1
tex -interaction=nonstopmode "\\def\\n{$N}\\input /app/collatz.tex" | sed -n 's/^RESULT //p'
cd / && rm -rf "$dir"
