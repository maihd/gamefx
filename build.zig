const std = @import("std");
const zmath = @import("libs/zig-gamedev/libs/zmath/build.zig");

pub const pkg = std.build.Pkg{
    .name = "gamefx",
    .source = .{ .path = thisDir() ++ "/src/main.zig" },
    .dependencies = &[_]std.build.Pkg{
        zmath.pkg,
    }, 
};

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = .Debug;//b.standardReleaseOptions();
    const step = stepGameFX(b, target, mode);
    step.install();

    // Add test step

    const main_tests = b.addTest("src/test.zig");
    main_tests.setBuildMode(mode);
    link(main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    // Example applications

    const examples = .{
        @import("examples/neon_shooter/build.zig"),
        @import("examples/basic_window/build.zig"),
        @import("examples/input_mouse/build.zig"),
        @import("examples/input_keys/build.zig"),
        @import("examples/gui_demo/build.zig"),
        @import("examples/sprites/build.zig"),
        @import("examples/2048/build.zig"),
    };
    inline for (examples) |example| {
        installExample(b, example.build(b, target, mode), example.name);
    }
}

pub fn stepGameFX(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const step = b.addStaticLibrary(pkg.name, pkg.source.path);
    step.setBuildMode(mode);
    step.setTarget(target);

    // Main backend: raylib

    step.linkLibC();
    step.addIncludePath(thisDir() ++ "/libs/raylib/src");
    step.addIncludePath(thisDir() ++ "/libs/raygui/src");

    linkSystemDeps(step);

    // Sub backends: zmath, zgui, ztracy, zjobs, zpool

    step.addPackage(zmath.pkg);

    return step;
}

pub fn stepRaylib(b: *std.build.Builder, target: std.zig.CrossTarget, mode: std.builtin.Mode) *std.build.LibExeObjStep {
    const src_dir = thisDir() ++ "/libs/raylib/src";
    
    const step = b.addStaticLibrary("raylib", src_dir ++ "/raylib.h");
    step.setBuildMode(mode);
    step.setTarget(target);

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

pub fn link(exe: *std.build.LibExeObjStep) void {
    exe.linkLibC();
    exe.linkLibrary(stepRaylib(exe.builder, exe.target, exe.build_mode));
    exe.linkLibrary(stepGameFX(exe.builder, exe.target, exe.build_mode));
    exe.addIncludePath(thisDir() ++ "/libs/raylib/src");
    exe.addIncludePath(thisDir() ++ "/libs/raygui/src");

    exe.addPackage(zmath.pkg);
    exe.addPackage(pkg);

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
    exe.strip = exe.build_mode == .ReleaseFast;

    comptime var desc_name: [name.len]u8 = [_]u8{0} ** name.len;
    comptime _ = std.mem.replace(u8, name, "_", " ", desc_name[0..]);
    comptime var desc_size = desc_name.len;

    const install = b.step(name, "Build '" ++ desc_name[0..desc_size] ++ "' example");
    install.dependOn(&b.addInstallArtifact(exe).step);

    const run_step = b.step(name ++ "_run", "Run '" ++ desc_name[0..desc_size] ++ "' example");
    const run_cmd = exe.run();
    run_cmd.step.dependOn(install);
    run_step.dependOn(&run_cmd.step);

    b.getInstallStep().dependOn(install);
}

inline fn thisDir() []const u8 {
    return comptime std.fs.path.dirname(@src().file) orelse ".";
}