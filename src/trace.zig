const raylib = @import("backends/raylib.zig");
const text = @import("text.zig");

pub fn info(comptime fmt: []const u8, args: anytype) void {
    const log_text = text.format(fmt, args) catch return;
    raylib.TraceLog(raylib.LOG_INFO, @ptrCast([*c]const u8, log_text));
}

pub fn warn(comptime fmt: []const u8, args: anytype) void {
    const log_text = text.format(fmt, args) catch return;
    raylib.TraceLog(raylib.LOG_WARNING, @ptrCast([*c]const u8, log_text));
}

pub fn @"error"(comptime fmt: []const u8, args: anytype) void {
    const log_text = text.format(fmt, args) catch return;
    raylib.TraceLog(raylib.LOG_ERROR, @ptrCast([*c]const u8, log_text));
}

pub fn fatal(comptime fmt: []const u8, args: anytype) void {
    const log_text = text.format(fmt, args) catch return;
    raylib.TraceLog(raylib.LOG_FATAL, @ptrCast([*c]const u8, log_text));
}

pub fn debug(comptime fmt: []const u8, args: anytype) void {
    const log_text = text.format(fmt, args) catch return;
    raylib.TraceLog(raylib.LOG_DEBUG, @ptrCast([*c]const u8, log_text));
}