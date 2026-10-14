#!/bin/sh
# INTERCAL reads numbers spelled out digit by digit ("TWO SEVEN") and writes
# butchered Roman numerals: a line of overbars (times 1000) above the letters,
# where lowercase letters also mean times a million. This translates both ways.
echo "$N" |
    sed 's/0/ZERO /g; s/1/ONE /g; s/2/TWO /g; s/3/THREE /g; s/4/FOUR /g;
         s/5/FIVE /g; s/6/SIX /g; s/7/SEVEN /g; s/8/EIGHT /g; s/9/NINE /g' |
    /app/collatz |
    awk 'NR == 1 { bars = $0; next }
         NR == 2 {
             split("1 5 10 50 100 500 1000", worth, " ")
             n = length($0)
             for (i = 1; i <= n; i++) {
                 c = substr($0, i, 1)
                 v[i] = worth[index("IVXLCDM", toupper(c))]
                 if (c != toupper(c)) v[i] *= 1000000
                 if (substr(bars, i, 1) == "_") v[i] *= 1000
             }
             for (i = 1; i <= n; i++) total += (i < n && v[i] < v[i + 1]) ? -v[i] : v[i]
             printf "%d\n", total
         }'
