# One hailstone step in Nix, the language your package manager is configured in.
# Mind the spaces: n/2 would be a path, n / 2 is a division.
{ n }: if builtins.bitAnd n 1 == 0 then n / 2 else 3 * n + 1
