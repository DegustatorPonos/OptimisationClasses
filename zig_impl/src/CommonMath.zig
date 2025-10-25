const std = @import("std");
const math = std.math;

pub fn Round(comptime T: type, num: T, n: f64) T {
    var shifted: T = num * math.pow(T, 10, n);
    shifted = math.round(shifted);
    return shifted / math.pow(T, 10, n);
}
