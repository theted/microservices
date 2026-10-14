-- One hailstone step in Lean 4, a theorem prover that also compiles programs.
def step (n : Nat) : Nat :=
  if n % 2 = 0 then n / 2 else 3 * n + 1

-- Proved once, at compile time, for every n: an even number gets halved.
theorem step_of_even (n : Nat) (h : n % 2 = 0) : step n = n / 2 := by
  simp [step, h]

-- And an odd one goes up.
theorem step_of_odd (n : Nat) (h : n % 2 = 1) : step n = 3 * n + 1 := by
  simp [step, h]

-- That every n eventually reaches 1 is the Collatz conjecture, which nobody
-- has proved. That theorem is left as an exercise.

def main : IO Unit := do
  let line ← (← IO.getStdin).getLine
  match line.trimAscii.toNat? with
  | some n => IO.println (step n)
  | none => IO.Process.exit 1
