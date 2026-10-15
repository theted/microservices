! One hailstone step in Factor, a concatenative language: words take their
! arguments from the stack and leave their results on it, so step is just
! "duplicate n, ask if it's even, then halve it or triple it and add one".
USING: io kernel math math.parser ;
IN: collatz

: step ( n -- n' ) dup even? [ 2 /i ] [ 3 * 1 + ] if ;

readln string>number step number>string print
