const std = @import("std");
const gamefx = @import("../../build.zig");

pub const name = "gui_demo";

pub fn build(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const src_dir = thisDir() ++ "/src";
    const exe = b.addExecutable("gui_demo", src_dir ++ "/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    gamefx.link(exe);
    exe.addPackage(gamefx.pkg);

    return exe;
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}