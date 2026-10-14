<?php
// One hailstone step in PHP.
function step(int $n): int
{
    return $n % 2 === 0 ? intdiv($n, 2) : 3 * $n + 1;
}

echo step((int) fgets(STDIN)), "\n";
