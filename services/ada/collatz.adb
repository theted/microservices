--  One hailstone step in Ada, the language the US Department of Defense
--  commissioned so that its software would never surprise anyone.
with Ada.Text_IO;                    use Ada.Text_IO;
with Ada.Long_Long_Integer_Text_IO; use Ada.Long_Long_Integer_Text_IO;

procedure Collatz is
   N : Long_Long_Integer;
begin
   Get (N);
   if N mod 2 = 0 then
      N := N / 2;
   else
      N := 3 * N + 1;
   end if;
   Put (N, Width => 0);
   New_Line;
end Collatz;
