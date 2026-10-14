-- One hailstone step in SQL: a single SELECT. sqlite3 binds :n from the command line.
SELECT CASE WHEN :n % 2 = 0 THEN :n / 2 ELSE 3 * :n + 1 END;
