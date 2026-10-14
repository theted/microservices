# One hailstone step in Elixir.
defmodule Collatz do
  def step(n) when rem(n, 2) == 0, do: div(n, 2)
  def step(n), do: 3 * n + 1
end

IO.gets("") |> String.trim() |> String.to_integer() |> Collatz.step() |> IO.puts()
