const std = @import("std");
const window = @import("window.zig");

pub fn format(comptime fmt: []const u8, args: anytype) ![]u8 {
    return std.fmt.allocPrintZ(window.getFrameAllocator(), fmt, args);
}

pub fn allocFormat(allocator: std.mem.Allocator, comptime fmt: []const u8, args: anytype) ![]u8 {
    return std.fmt.allocPrintZ(allocator, fmt, args);
}