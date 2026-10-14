# One hailstone step in Python.
def step(n: int) -> int:
    return n // 2 if n % 2 == 0 else 3 * n + 1


print(step(int(input())))
