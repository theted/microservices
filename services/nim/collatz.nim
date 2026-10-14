# One hailstone step in Nim.
import std/strutils

proc step(n: int): int =
  if n mod 2 == 0: n div 2 else: 3 * n + 1

echo step(stdin.readLine.strip.parseInt)
