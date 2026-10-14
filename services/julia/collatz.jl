# One hailstone step in Julia.
step(n::Integer) = iseven(n) ? n ÷ 2 : 3n + 1

println(step(parse(Int, readline())))
