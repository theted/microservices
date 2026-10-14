dnl One hailstone step in m4, the macro processor from 1977. There is no
dnl input to read: n arrives as a macro definition on the command line.
define(`step', `ifelse(eval($1 % 2), 0, eval($1 / 2), eval(3 * $1 + 1))')dnl
step(N)
