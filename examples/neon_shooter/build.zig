const std = @import("std");
const gamefx = @import("../../build.zig");

pub const name = "neon_shooter";

pub fn build(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const src_dir = thisDir() ++ "/src";
    const exe = b.addExecutable("neon_shooter", src_dir ++ "/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    // Add assets folder
    const assets_dir = thisDir() ++ "/assets";
    const exe_options = b.addOptions();
    exe.addOptions("build_options", exe_options);
    exe_options.addOption([]const u8, "assets_dir", assets_dir);

    gamefx.link(exe);
    exe.addPackage(gamefx.pkg);

    return exe;
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}