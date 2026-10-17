begin
   comment One hailstone step in ALGOL 60, the language whose report gave us
      BNF, block structure, and the begin ... end you still type today.
      In marst's spelling, % is integer division;
   integer n;
   ininteger(0, n);
   outinteger(1, if n - n % 2 * 2 = 0 then n % 2 else 3 * n + 1)
end
