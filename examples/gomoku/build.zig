const std = @import("std");
const gamefx = @import("../../build.zig");

pub const name = "gomoku";

pub fn build(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const src_dir = thisDir() ++ "/src";
    const exe = b.addExecutable(.{
        .name = name, 
        .root_source_file = .{ .path = src_dir ++ "/main.zig" },
        .target = target,
        .optimize = mode
    });

    gamefx.link(b, target, mode, exe);

    // Add test step

    const main_tests = b.addTest(.{
        .name = name ++ "-tests",
        .root_source_file = .{ .path = src_dir ++ "/main.zig" },
        .target = target,
        .optimize = mode
    });

    const test_step = b.step(name ++ "_test", "Run Gomoku logic tests");
    test_step.dependOn(&main_tests.step);

    return exe;
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}