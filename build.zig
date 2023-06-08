const std = @import("std");
const zmath = @import("libs/zig-gamedev/zmath/build.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = .Debug;//b.standardReleaseOptions();

    //const step = stepGameFX(b, target, mode);
    //step.install();

    // Add test step

    const main_tests = b.addTest(.{
        .name = "gamefx-tests",
        .root_source_file = .{ .path = thisDir() ++ "src/test.zig" },
        .target = target,
        .optimize = mode,
    });
    //main_tests.setBuildMode(mode);
    link(b, target, mode, main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    // Example applications

    const examples = .{
        // @import("examples/neon_shooter/build.zig"),
        // @import("examples/basic_window/build.zig"),
        // @import("examples/input_mouse/build.zig"),
        // @import("examples/input_keys/build.zig"),
        // @import("examples/gui_demo/build.zig"),
        // @import("examples/sprites/build.zig"),
        @import("examples/gomoku/build.zig"),
        // @import("examples/2048/build.zig"),
    };
    inline for (examples) |example| {
        installExample(b, example.build(b, target, mode), example.name);
    }
}

pub fn stepGameFX(b: *std.Build, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const step = b.addStaticLibrary(.{ 
        .name = "gamefx", 
        .root_source_file = .{ .path = thisDir() ++ "/src/main.zig" },
        .target = target,
        .optimize = mode
    });

    // Main backend: raylib

    step.linkLibC();
    step.addIncludePath(thisDir() ++ "/libs/raylib-4.2.0/src");
    step.addIncludePath(thisDir() ++ "/libs/raygui-3.2/src");

    linkSystemDeps(step);

    // Sub backends: zmath, zgui, ztracy, zjobs, zpool

    const zmath_package = zmath.package(b, target, mode, .{});
    step.addModule("zmath", zmath_package.zmath);

    return step;
}

pub fn stepRaylib(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const src_dir = thisDir() ++ "/libs/raylib-4.2.0/src";
    
    const step = b.addStaticLibrary(.{
        .name = "raylib", 
        .root_source_file = .{ .path = src_dir ++ "/raylib.h" },
        .target = target,
        .optimize = mode
    });

    // Compile sources

    const c_flags = &[_][]const u8{
        "-std=gnu99",
        "-DPLATFORM_DESKTOP",
        "-DGL_SILENCE_DEPRECATION=199309L",
        "-fno-sanitize=undefined", // https://github.com/raysan5/raylib/issues/1891
    };

    step.linkLibC();
    step.addIncludePath(src_dir ++ "/external/glfw/include");
    step.addCSourceFiles(&.{
        src_dir ++ "/raudio.c",
        src_dir ++ "/rcore.c",
        src_dir ++ "/rmodels.c",
        src_dir ++ "/rshapes.c",
        src_dir ++ "/rtext.c",
        src_dir ++ "/rtextures.c",
        src_dir ++ "/utils.c",
    }, c_flags);

    switch (step.target.toTarget().os.tag) {
        .windows => {
            step.addCSourceFiles(&.{src_dir ++ "/rglfw.c"}, c_flags);
        },
        .linux => {
            step.addCSourceFiles(&.{src_dir ++ "/rglfw.c"}, c_flags);
        },
        .freebsd, .openbsd, .netbsd, .dragonfly => {
            step.addCSourceFiles(&.{src_dir ++ "/rglfw.c"}, c_flags);
        },
        .macos => {
            // On macos rglfw.c include Objective-C files.
            const c_flags_extra_macos = &[_][]const u8{
                "-ObjC",
            };
            step.addCSourceFiles(
                &.{src_dir ++ "/rglfw.c"},
                c_flags ++ c_flags_extra_macos,
            );
        },
        else => {
            @panic("Unsupported OS");
        },
    }

    // Linking system deps

    linkSystemDeps(step);
    
    // Complete

    return step;
}

pub fn link(b: *std.Build, target: std.zig.CrossTarget, mode: std.builtin.Mode, exe: *std.build.LibExeObjStep) void {
    exe.linkLibC();
    exe.linkLibrary(stepRaylib(b, target, mode));
    exe.linkLibrary(stepGameFX(b, target, mode));
    exe.addIncludePath(thisDir() ++ "/libs/raylib-4.2.0/src");
    exe.addIncludePath(thisDir() ++ "/libs/raygui-3.2/src");

    const zmath_package = zmath.package(b, target, mode, .{});

    const gamefx_module = b.createModule(.{
        .source_file = .{ .path = thisDir() ++ "/src/main.zig" },
        .dependencies = &.{
            .{ .name = "zmath", .module = zmath_package.zmath },
        }
    });

    exe.addModule("gamefx", gamefx_module);

    linkSystemDeps(exe);
}

pub fn linkSystemDeps(step: *std.build.LibExeObjStep) void {
    const target_os = step.target.toTarget().os.tag;
    switch (target_os) {
        .windows => {
            step.linkSystemLibrary("winmm");
            step.linkSystemLibrary("gdi32");
            step.linkSystemLibrary("opengl32");
        },
        .macos => {
            step.linkFramework("OpenGL");
            step.linkFramework("Cocoa");
            step.linkFramework("IOKit");
            step.linkFramework("CoreAudio");
            step.linkFramework("CoreVideo");
        },
        .freebsd, .openbsd, .netbsd, .dragonfly => {
            step.linkSystemLibrary("GL");
            step.linkSystemLibrary("rt");
            step.linkSystemLibrary("dl");
            step.linkSystemLibrary("m");
            step.linkSystemLibrary("X11");
            step.linkSystemLibrary("Xrandr");
            step.linkSystemLibrary("Xinerama");
            step.linkSystemLibrary("Xi");
            step.linkSystemLibrary("Xxf86vm");
            step.linkSystemLibrary("Xcursor");
        },
        else => { // linux and possibly others
            step.linkSystemLibrary("GL");
            step.linkSystemLibrary("rt");
            step.linkSystemLibrary("dl");
            step.linkSystemLibrary("m");
            step.linkSystemLibrary("X11");
        },
    }
}

pub fn installExample(b: *std.build.Builder, exe: *std.build.LibExeObjStep, comptime name: []const u8) void {
    // TODO: Problems with LTO on Windows.
    exe.want_lto = false;
    exe.strip = false;

    comptime var desc_name: [name.len]u8 = [_]u8{0} ** name.len;
    comptime _ = std.mem.replace(u8, name, "_", " ", desc_name[0..]);
    comptime var desc_size = desc_name.len;

    const install = b.step(name, "Build '" ++ desc_name[0..desc_size] ++ "' example");
    install.dependOn(&b.addInstallArtifact(exe).step);

    const run_step = b.step(name ++ "_run", "Run '" ++ desc_name[0..desc_size] ++ "' example");
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(install);
    run_step.dependOn(&run_cmd.step);

    b.getInstallStep().dependOn(install);
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}