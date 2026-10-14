{ One hailstone step in Pascal, as taught in every 1985 computer science course. }
program Collatz;

var
  n: Int64;

begin
  ReadLn(n);
  if n mod 2 = 0 then
    n := n div 2
  else
    n := 3 * n + 1;
  WriteLn(n);
end.
