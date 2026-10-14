" One hailstone step in Vim script.
" Emacs serves HTTP down the hall. Vim won't stoop to that: it writes the
" answer into a buffer and prints it, the way it has since 1991.
let s:n = str2nr($N)
call setline(1, string(s:n % 2 == 0 ? s:n / 2 : 3 * s:n + 1))
%print
qall!
