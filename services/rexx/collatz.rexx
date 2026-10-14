/* One hailstone step in REXX, IBM's mainframe scripting language from 1979. */
/* In REXX, // is the remainder and % is integer division. Of course.       */
numeric digits 20
parse pull n
if n // 2 = 0 then say n % 2
else say 3 * n + 1
