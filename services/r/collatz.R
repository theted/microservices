# One hailstone step in R.
step <- function(n) if (n %% 2 == 0) n %/% 2 else 3 * n + 1

n <- as.numeric(readLines(file("stdin"), n = 1))
cat(sprintf("%.0f\n", step(n)))
