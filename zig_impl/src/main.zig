const std = @import("std");
const stdout = std.io.getStdOut().writer();
const math = std.math;
const fov = @import("FOV.zig").FOV;
const ftv = @import("FMV.zig").FMV;
const isn = @import("SmallNumbers.zig").ISN;

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
// const lib = @import("optim_zig_lib");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();
    try tableTest(allocator);
    var one_var_func = try fov.Create(allocator, baseFx);
    defer allocator.destroy(one_var_func);

    try stdout.print("F'(1) = {d}\n", .{one_var_func.Df_right(1, 1e-10)});
    try stdout.print("Expected F'(1) = {d}\n", .{derivedFx(1)});
}

fn baseFx(x: f64) f64 {
    return math.sin(x);
}

fn derivedFx(x: f64) f64 {
    return math.cos(x);
}

// Linking tests from FOV class impl
test {
    _ = fov;
    _ = ftv;
    _ = isn;
}

