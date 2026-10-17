// One hailstone step in Objective-C: a class method, sent as a message.
#import <objc/Object.h>
#include <stdio.h>

@interface Hailstone : Object
+ (long)step:(long)n;
@end

@implementation Hailstone
+ (long)step:(long)n {
    return n % 2 == 0 ? n / 2 : 3 * n + 1;
}
@end

int main(void) {
    long n;
    if (scanf("%ld", &n) != 1) {
        return 1;
    }
    printf("%ld\n", [Hailstone step:n]);
    return 0;
}
