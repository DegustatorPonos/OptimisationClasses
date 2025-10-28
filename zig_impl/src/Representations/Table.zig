const std = @import("std");
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
        const records = std.ArrayList([]const f64){};
        return Table {
            .Allocator = alloc,
            .Columns = columns,
            .Rows = 0,
            .Titles = titles,
            .Records = records
        };
    }

    pub fn Deinit(self: *Table) void {
        self.Records.deinit(self.Allocator);
    }

    pub fn AddRecord(self: *Table, values: []const f64) !void {
        if (values.len != self.Columns) return errors.InvalidRecordLength;
        try self.Records.append(self.Allocator, values);
    }

    pub fn Print(self: *Table) !void {
        try self.printHeader();
        for (0..self.Records.items.len) |val| {
            try self.printRow(val);
        }
    }

    fn printHeader(self: Table) !void {
        std.debug.print("| ", .{});
        for (self.Titles) |i| {
            std.debug.print("{s} | ", .{i});
        }
        std.debug.print("\n", .{});
    }

    fn printRow(self: Table, i: usize) !void {
        if (self.Records.items.len <= i) return;
        const row = self.Records.items[i];
        std.debug.print("| ", .{});
        for (0.., row) |j, val| {
            const rounded = math2.Round(f64, val, self.RoundTo);
            const rowLen = self.Titles[j].len; // So that all that shit alignes
            const num_len = math2.FloatStrLength(rounded, self.RoundTo);
            if (num_len > rowLen) {
                std.debug.print("...", .{});
                for (2..rowLen) |_| {
                    std.debug.print(" ", .{});
                }
                std.debug.print("| ", .{});
                continue;
            }
            std.debug.print("{d} ", .{rounded});
            for (num_len..rowLen) |_| {
                std.debug.print(" ", .{});
            }
            std.debug.print("| ", .{});
        }
        std.debug.print("\n", .{});
    }

};
