// One hailstone step in Kotlin.
fun step(n: Long): Long = if (n % 2 == 0L) n / 2 else 3 * n + 1

fun main() = println(step(readln().trim().toLong()))
