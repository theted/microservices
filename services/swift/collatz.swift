// One hailstone step from Swift. It never touches a socket: the shim hands
// over a line, and Swift hands one back.
func step(_ n: Int) -> Int {
    n % 2 == 0 ? n / 2 : 3 * n + 1
}

if let line = readLine(), let n = Int(line), n > 0 {
    print(step(n))
}
