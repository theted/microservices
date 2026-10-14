// One hailstone step in modern C++. The interesting part happens before it
// ever runs: the compiler checks the step function, or refuses to build.
#include <cstdint>
#include <iostream>

constexpr std::uint64_t step(std::uint64_t n) {
    return n % 2 == 0 ? n / 2 : 3 * n + 1;
}

consteval std::uint64_t steps_to_one(std::uint64_t n) {
    std::uint64_t steps = 0;
    for (; n != 1; ++steps) {
        n = step(n);
    }
    return steps;
}

static_assert(step(27) == 82);
static_assert(step(82) == 41);
static_assert(step(1) == 4, "1 goes back to 4: the only cycle anyone has found");
static_assert(steps_to_one(27) == 111, "27 takes 111 steps, counted by the compiler");

int main() {
    std::uint64_t n = 0;
    if (!(std::cin >> n) || n == 0) {
        return 1;
    }
    std::cout << step(n) << '\n';
}
