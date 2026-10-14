// One hailstone step in C#.
static long Step(long n) => n % 2 == 0 ? n / 2 : 3 * n + 1;

Console.WriteLine(Step(long.Parse(Console.ReadLine()!)));
