// One hailstone step from Zig 0.16, where even stdin and stdout go through an explicit Io.
const std = @import("std");

fn step(n: u64) u64 {
    return if (n % 2 == 0) n / 2 else 3 * n + 1;
}

pub fn main(init: std.process.Init) !void {
    var in_buffer: [64]u8 = undefined;
    var stdin = std.Io.File.stdin().reader(init.io, &in_buffer);
    const line = try stdin.interface.takeDelimiter('\n') orelse return error.NoInput;
    const n = try std.fmt.parseUnsigned(u64, std.mem.trim(u8, line, " \r"), 10);
    if (n == 0) return error.NotPositive;

    var out_buffer: [64]u8 = undefined;
    var stdout = std.Io.File.stdout().writer(init.io, &out_buffer);
    try stdout.interface.print("{d}\n", .{step(n)});
    try stdout.interface.flush();
}
