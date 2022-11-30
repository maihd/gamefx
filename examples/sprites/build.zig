const std = @import("std");
const gamefx = @import("../../build.zig");

pub const name = "sprites";
pub const assets_dir = "assets/";

pub fn build(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const src_dir = thisDir() ++ "/src";
    const exe = b.addExecutable("sprites", src_dir ++ "/main.zig");
    
    // Add assets_dir to source

    const exe_options = b.addOptions();
    exe.addOptions("build_options", exe_options);
    exe_options.addOption([]const u8, "assets_dir", thisDir() ++ "/" ++ assets_dir);

    exe.setTarget(target);
    exe.setBuildMode(mode);

    gamefx.link(exe);
    exe.addPackage(gamefx.pkg);

    return exe;
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}