# One hailstone step in Ruby.
def step(n) = n.even? ? n / 2 : 3 * n + 1

puts step(gets.to_i)
