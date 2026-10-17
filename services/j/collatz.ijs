NB. One hailstone step in J. Read right to left: 2&| is n mod 2, and @. uses it
NB. to pick a verb from the gerund on its left: -: (halve) or >:@(3&*) (triple, then increment).
step =: -:`(>:@(3&*))@.(2&|)
echo step ". (stdin '') -. LF
exit ''
