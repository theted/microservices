# One hailstone step in awk: a pattern-less rule that runs on the one input line.
{ print $1 % 2 ? 3 * $1 + 1 : $1 / 2 }
