// One hailstone step in D.
import std.conv : to;
import std.stdio : readln, writeln;
import std.string : strip;

long step(long n) {
    return n % 2 == 0 ? n / 2 : 3 * n + 1;
}

void main() {
    writeln(step(readln.strip.to!long));
}
