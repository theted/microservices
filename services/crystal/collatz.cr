# One hailstone step in Crystal. (n * 3, not 3 * n: Int32 * Int64 is an Int32.)
def step(n : Int64) : Int64
  n.even? ? n // 2 : n * 3 + 1
end

puts step(STDIN.gets.not_nil!.strip.to_i64)
