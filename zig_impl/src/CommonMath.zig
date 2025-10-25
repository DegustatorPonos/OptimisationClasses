const std = @import("std");
const math = std.math;
const stdout = std.io.getStdOut().writer();

pub fn Round(comptime T: type, num: T, n: f64) T {
    var shifted: T = num * math.pow(T, 10, n);
    shifted = @round(shifted);
    return shifted / math.pow(T, 10, n);
}

test "AllNumbers" {
    var start: f64 = 0.987;
    while (start < 1) : (start += 0.001) {
        const rounded1 = Round(f64, start, 3);
        const rounded2 = Round(f64, rounded1, 3);
        std.debug.print("Number: {d}, r1: {d}, r2: {d}\n", .{start, rounded1, rounded2});
        try expect(FloatStrLength(rounded2, 0) < 5 and FloatStrLength(rounded1, 0) < 5);
    }
}

pub fn IntStrLength(inp: i64) u64 {
    var input = inp;
    var outp: u64 = 1;
    while (input >= 10) {
        outp += 1;
        input = @divFloor(input, 10);
    }
    return outp;
}

pub fn FloatStrLength(inp: f64, maxDecimal: f64) u64 {
    var input = inp;
    var outp: u64 = IntStrLength(@intFromFloat(inp));
    if (@rem(input, 1) != 0)
        outp += 1; // Dot
    var iter: f64 = 0;
    while (@rem(input, 1) != 0) {
        outp += 1;
        input *= 10;
        iter += 1;
        if (iter >= maxDecimal) break;
    }
    return outp;
}


const expect = std.testing.expect;

test "IntStrLength" {
    try expect(IntStrLength(1234) == 4);
    try expect(IntStrLength(0) == 1);
}

test "FloatStrLength" {
    try expect(FloatStrLength(1.23, 3) == 4);
}
