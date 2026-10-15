# One hailstone step in gnuplot, which would much rather be drawing a graph.
# print goes to stderr unless told otherwise, hence set print "-".
set print "-"
n = int(ARG1)
print (n % 2 == 0) ? n / 2 : 3 * n + 1
