const math = std.math;
const std = @import("std");
const stdout = std.io.getStdOut().writer();
const expect = std.testing.expect;

pub const ISN = struct {
    const machineEpsilon: f64 = 1e-16;
    const machineZero : f64 = 1e-308;

    bf: *const fn(f64)f64,

    pub fn Init(fx: *const fn(f64)f64) ISN {
        return ISN {
            .bf = fx
        };
    }

    pub fn Create(a: std.mem.Allocator, fx: *const fn(f64)f64) !*ISN {
        const outp = try a.create(ISN);
        outp.* = Init(fx);
        return outp;
    }

    pub fn IsISN (self: ISN) bool {
        // (lim f(x); x -> 0) = 0
        return @abs(self.bf(machineZero)) <= machineZero;
    }

    // pub fn CreateTable()
};

fn isnFunc(x: f64) f64 {
    return math.pow(f64, x, 121);
}

fn notIsnFunc(x: f64) f64 {
    return math.pow(f64, x, 2) + 1;
}

// Tests the capability of identifying infinitely small functions
test "IsIsn" {
    const passingISN = ISN.Init(isnFunc);
    try expect(passingISN.IsISN());
    const failingISN = ISN.Init(notIsnFunc);
    try expect(!failingISN.IsISN());
}
