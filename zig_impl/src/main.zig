const std = @import("std");
const stdout = std.io.getStdOut().writer();
const math = std.math;
const fov = @import("FOV.zig").FOV;
const ftv = @import("FMV.zig").FMV;
const isn = @import("SmallNumbers.zig").ISN;
const table = @import("Representations/Table.zig").Table;
const math2 = @import("CommonMath.zig");

/// This imports the separate module containing `root.zig`. Take a look in `build.zig` for details.
// const lib = @import("optim_zig_lib");

pub fn main() !void {
    const start: f64 = 0.987;
    try stdout.print("{d}\n", .{start});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();
    try tableTest(allocator);
    var one_var_func = try fov.Create(allocator, baseFx);
    defer allocator.destroy(one_var_func);

    try stdout.print("F'(1) = {d}\n", .{one_var_func.Df_right(1, 1e-10)});
    try stdout.print("Expected F'(1) = {d}\n", .{derivedFx(1)});
}

fn tableTest(alloc: std.mem.Allocator) !void {
    var t = try table.Init(alloc, 2, &[_][]const u8 {
        "Column 1",
        "Column 2"
    });
    defer t.Deinit();
    // var newRow = [_]f64 {1.5, 7.0/3.0 };
    try t.AddRecord(&[_]f64 {1, 721});
    try t.AddRecord(&[_]f64 {1.5, 7.0/3.0 });
    try t.AddRecord(&[_]f64 {12.987, 17.0/53.0 });
    try t.Print();
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

