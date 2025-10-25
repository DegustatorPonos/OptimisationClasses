const std = @import("std");
const stdout = std.io.getStdOut().writer();
const math = std.math;
const math2 = @import("../CommonMath.zig");

const errors = error {
    InvalidTitlesLength,
    InvalidRecordLength
};

pub const Table = struct { 
    Allocator: std.mem.Allocator,
    Columns: u64,
    Rows: u64,
    Titles: []const []const u8,
    Records: std.ArrayList([]const f64),
    RoundTo: f64 = 3,

    pub fn Init(alloc: std.mem.Allocator, columns: u64, titles: []const[]const u8) !Table {
        if (titles.len != columns) return errors.InvalidTitlesLength;
        const records = std.ArrayList([]const f64).init(alloc);
        return Table {
            .Allocator = alloc,
            .Columns = columns,
            .Rows = 0,
            .Titles = titles,
            .Records = records
        };
    }

    pub fn Deinit(self: *Table) void {
        self.Records.deinit();
    }

    pub fn AddRecord(self: *Table, values: []const f64) !void {
        if (values.len != self.Columns) return errors.InvalidRecordLength;
        try self.Records.append(values);
    }

    pub fn Print(self: *Table) !void {
        try self.printHeader();
        for (0..self.Records.items.len) |val| {
            try self.printRow(val);
        }
    }

    fn printHeader(self: Table) !void {
        try stdout.print("| ", .{});
        for (self.Titles) |i| {
            try stdout.print("{s}\t| ", .{i});
        }
        try stdout.print("\n", .{});
    }

    fn printRow(self: Table, i: usize) !void {
        if (self.Records.items.len <= i) return;
        const row = self.Records.items[i];
        try stdout.print("| ", .{});
        for (row) |val| {
            try stdout.print("{d}\t| ", .{math2.Round(f64, val, self.RoundTo)});
        }
        try stdout.print("\n", .{});
    }
};
