const math = std.math;
const std = @import("std");
const stdout = std.io.getStdOut().writer();
const expect = std.testing.expect;

const lambda: f64 = (math.sqrt(5) - 1) / 2;
const h_opt_default: f64 = 1e-10;

pub const FMV = struct {
    n: usize,
    fx: *const fn([]f64)f64,

    pub fn Init(fx: fn([]f64)f64, vars: usize) FMV {
        return FMV {
            .fx = fx,
            .n = vars,
        };
    }

    pub fn Create(a: std.mem.Allocator, fx: fn([]f64)f64, vars: usize) !*FMV {
        const outp = try a.create(FMV);
        outp.* = Init(fx, vars);
        return outp;
    }

    pub fn Exec(self: FMV, x0: []f64) f64 {
        return self.fx(x0);
    }

    pub fn Gradient(self: FMV, alloc: std.mem.Allocator, x0: []f64, h_opt: f64) ![]f64 {
        const fx0 = self.fx(x0);
        var gr: []f64 = try alloc.alloc(f64, self.n);
        for (0..self.n) |i| {
            x0[i] += h_opt;
            const fx = self.fx(x0);
            gr[i] = (fx - fx0) / h_opt;
            x0[i] -= h_opt;
        }
        return gr;
    }

};

fn test_method (vars: []f64) f64 {
    if (vars.len != 2) {
        return -1;
    }
    return vars[0] * vars[0] + 2 * vars[1] * vars[1] - vars[1];
}

test "Two vars funtion exec" {
    // const fmv = FMV.Init(test_method, 2);
    // const x0 = &[_]f64{1, 2};
    // try expect(fmv.Exec(&([2]f64{1, 2})) != 6);
}

test "Two variable function differential" {
    const alloc = std.testing.allocator;
    const fmv = FMV.Init(test_method, 2);
    var x0 : [2]f64 = .{1, 1};
    const answer = [_]f64{2, 3};
    const res = try fmv.Gradient(alloc, &x0, h_opt_default);
    defer alloc.free(res);
    const allowed = 1e-6;
    try expect(@abs(res[0] - answer[0]) < allowed and @abs(res[1] - answer[1]) < allowed);
}
