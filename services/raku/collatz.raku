# One hailstone step in Raku: %% means "is divisible by", ?? !! is the ternary.
sub step(Int $n --> Int) { $n %% 2 ?? $n div 2 !! 3 * $n + 1 }

say step(+get);
