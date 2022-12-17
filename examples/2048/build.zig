const std = @import("std");
const gamefx = @import("../../build.zig");

pub const name = "2048";

pub fn build(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const src_dir = thisDir() ++ "/src";
    const exe = b.addExecutable(name, src_dir ++ "/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    gamefx.link(exe);
    exe.addPackage(gamefx.pkg);

    // Add test step

    const main_tests = b.addTest(src_dir ++ "/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step(name ++ "_test", "Run 2048 logic tests");
    test_step.dependOn(&main_tests.step);

    return exe;
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}