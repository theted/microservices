#!/bin/sh
# Opens a spreadsheet for every single number. LibreOffice can't share its
# profile between two instances, so requests take turns.
dir=$(mktemp -d) || exit 1
trap 'rm -rf "$dir"' EXIT
sed "s/__N__/$N/" /app/collatz.fods > "$dir/collatz.fods"
flock /tmp/calc.lock soffice -env:UserInstallation=file:///app/profile --headless --norestore \
    --convert-to csv --outdir "$dir" "$dir/collatz.fods" > /dev/null 2>&1
cut -d, -f2 "$dir/collatz.csv"
