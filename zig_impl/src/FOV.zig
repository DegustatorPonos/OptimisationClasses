const math = std.math;
const std = @import("std");
const stdout = std.io.getStdOut().writer();
const expect = std.testing.expect;

const lambda: f64 = (math.sqrt(5) - 1) / 2;

pub const triple = struct {
    a: f64,
    b: f64,
    c: f64,
};

pub const FOV = struct {
    pf: *const fn(f64)f64,

    pub fn Init(fx: *const fn(f64)f64) FOV {
        return FOV {
            .pf = fx
        };
    }

    pub fn Create(a: std.mem.Allocator, fx: *const fn(f64)f64) !*FOV {
        const outp = try a.create(FOV);
        outp.* = Init(fx);
        return outp;
    }

    pub fn Exec(self: FOV, x: f64) f64 {
        return self.pf(x);
    }

    pub fn Df_right(self: FOV, x0: f64, step: f64) f64 {
        const fp = self.pf;
        return (fp(x0+step) - fp(x0))/step;
    }

    pub fn FindLocal(self: FOV) struct {a: f64, b: f64, c: f64} {
        var x0: f64 = 0;
        var x1: f64 = 0;
        var x2: f64 = 0;
        var h: f64 = 0.1;
        if (self.pf(x0) < self.pf(x0 + h)) {
            h = -h;
        }
        x1 = x0 + h;
        x2 = x1 + (x1 - x0) * (1 + lambda);

        while (true) {
            if (self.IsLucky(x0, x1, x2)) {
                return .{.a = x0, .b = x1, .c = x2};
            } else {
                x0 = x1;
                x1 = x2;
                x2 = x1 + (x1 - x0) * (1 + lambda);
            }
        }

        return .{0};
    }

    pub fn IsLucky(self: FOV, a: f64, b: f64, c: f64, ) bool {
        const fa = self.pf(a);
        const fb = self.pf(b);
        const fc = self.pf(c);
        return fa > fb and fc > fb;
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
    const result = fov.Df_right(x0, 1e-10);
    const expected = derivedFx(x0);
    try expect(@abs(result - expected) < allowed_diff);
}

test "Find local" {
    const fov = FOV.Init(baseFx);
    const locals = fov.FindLocal();
    const fa = fov.Exec(locals.a);
    const fb = fov.Exec(locals.b);
    const fc = fov.Exec(locals.c);
    try expect(fa > fb);
    try expect(fc > fb);
}
