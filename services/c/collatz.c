// One hailstone step in C.
#include <stdio.h>

static unsigned long step(unsigned long n) {
    return n % 2 == 0 ? n / 2 : 3 * n + 1;
}

int main(void) {
    unsigned long n;
    if (scanf("%lu", &n) != 1) {
        return 1;
    }
    printf("%lu\n", step(n));
}
