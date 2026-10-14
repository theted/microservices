#!/bin/sh
# Ask every language in web/services.json a few questions through the gateway
# and check the answers against plain shell arithmetic.
#
#   docker compose up -d && scripts/smoke.sh
#
# The first column feeds it garbage and expects a 4xx; the rest are Collatz
# steps, ending with 9038141, the step that makes the biggest number any seed
# under 10,000 ever reaches (27,114,424).

set -u
cd "$(dirname "$0")/.." || exit 1

GATEWAY=${GATEWAY:-http://localhost:8080}
INPUTS="1 2 3 6 7 27 9232 9663 9038141"

ids=$(grep -o '"id": *"[^"]*"' web/services.json | sed 's/.*"\([^"]*\)"$/\1/')

for service in $(docker compose config --services); do
    case $service in gateway | runner) continue ;; esac
    echo "$ids" | grep -qx "$service" ||
        echo "⚠️  $service is in docker-compose.yml but not in web/services.json"
done

printf '%-12s %-6s %s\n' service junk "$INPUTS"
failures=0
for id in $ids; do
    status=$(curl -s -o /dev/null -w '%{http_code}' --max-time 15 "$GATEWAY/svc/$id/?n=banana")
    case $status in
        4??) line=$(printf '%-12s ✅    ' "$id") ;;
        *) line=$(printf '%-12s ❌%s ' "$id" "$status") && failures=$((failures + 1)) ;;
    esac
    for n in $INPUTS; do
        expected=$((n % 2 == 0 ? n / 2 : 3 * n + 1))
        got=$(curl -s --max-time 15 "$GATEWAY/svc/$id/?n=$n" | grep -oE -- '-?[0-9]+' | tail -n 1)
        if [ "$got" = "$expected" ]; then
            line="$line ✅"
        else
            line="$line ❌($n→${got:-nothing})"
            failures=$((failures + 1))
        fi
    done
    echo "$line"
done

if [ "$failures" -eq 0 ]; then
    echo "All good."
else
    echo "$failures failed checks."
    exit 1
fi
