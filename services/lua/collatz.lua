-- One hailstone step in Lua.
local function step(n)
  if n % 2 == 0 then return n // 2 end
  return 3 * n + 1
end

print(step(io.read("n")))
