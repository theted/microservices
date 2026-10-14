// One hailstone step in F#.
let step n = if n % 2L = 0L then n / 2L else 3L * n + 1L

stdin.ReadLine() |> int64 |> step |> printfn "%d"
