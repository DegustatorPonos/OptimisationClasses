const math = std.math;
const std = @import("std");
const stdout = std.io.getStdOut().writer();
const expect = std.testing.expect;

pub const FOV = struct {
    base_function: *const fn(f64)f64,

    pub fn Init(fx: *const fn(f64)f64) FOV {
        return FOV {
            .base_function = fx
        };
    }

    pub fn df_right(self: FOV, x0: f64, step: f64) f64 {
        const fp = self.base_function;
        return (fp(x0+step) - fp(x0))/step;
    }
};

fn baseFx(x: f64) f64 {
    return math.sin(x);
}

fn derivedFx(x: f64) f64 {
    return math.cos(x);
}

test "df right test" {
    const x0: f64 = 1;
    const allowed_diff: f64 = 1e-6;
    const fov = FOV.Init(baseFx);
    const result = fov.df_right(x0, 1e-10);
    const expected = derivedFx(x0);
    try expect(@abs(result - expected) < allowed_diff);
}
