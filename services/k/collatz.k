/ One hailstone step in K (ngn/k). $[c;t;f] is if-then-else, 2!x is x mod 2,
/ -2!x is x divided by 2, 0:0 reads stdin's lines, and `0: prints.
step:{$[2!x;1+3*x;-2!x]}
`0:$step@.*0:0
