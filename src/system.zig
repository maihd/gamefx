const std = @import("std");
const assets = @import("assets.zig");
const raylib = @import("backends/raylib.zig");

// Core

var is_init = false;

// Allocators

var frame_buffer: ?[]u8 = null;
var frame_allocator: std.heap.FixedBufferAllocator = undefined;

var default_assets_allocator_heap = std.heap.GeneralPurposeAllocator(.{}){};
const default_assets_allocator = default_assets_allocator_heap.allocator();

var default_backend_allocator_heap = std.heap.GeneralPurposeAllocator(.{}){};
const default_backend_allocator = default_backend_allocator_heap.allocator();

var assets_allocator: std.mem.Allocator = undefined;
var backend_allocator: std.mem.Allocator = undefined;

// Native bindings

comptime {
    @import("meta/calloc.zig").wrapAllocator(struct {
        pub fn getAllocator(self: @This()) std.mem.Allocator {
            _ = self;
            return backend_allocator;
        }
    }).exportAs(.{
        .malloc     = "gamefx_backend_malloc",
        .calloc     = "gamefx_backend_calloc",
        .realloc    = "gamefx_backend_realloc",
        .free       = "gamefx_backend_free"
    });
}

// Functions

pub const Config = struct {
    title: []const u8,
    width: i32,
    height: i32,

    framerate: i32 = 60,

    frame_buffer: ?[]u8 = null,

    assets_allocator: std.mem.Allocator = default_assets_allocator,
    backend_allocator: std.mem.Allocator = default_backend_allocator,
};

pub fn init(config: Config) !void {
    if (config.title.len == 0) {
        return error.TitleInvalid;
    }

    if (config.width <= 0) {
        return error.WidthInvalid;
    }

    if (config.height <= 0) {
        return error.HeightInvalid;
    }

    if (config.framerate <= 0) {
        return error.FramerateInvalid;
    }

    raylib.InitWindow(config.width, config.height, @ptrCast([*c]const u8, config.title));
    if (!raylib.IsWindowReady()) {
        return error.FailedToInitWindow;
    }

    raylib.InitAudioDevice();
    if (!raylib.IsAudioDeviceReady()) {
        return error.FailedToInitAudio;
    }

    raylib.SetTargetFPS(config.framerate);

    if (config.frame_buffer) |buffer| {
        frame_allocator = std.heap.FixedBufferAllocator.init(buffer);
    } else {
        const frame_buffer_size = 10 * 1024 * 1024;
        frame_buffer = try std.heap.page_allocator.alloc(u8, frame_buffer_size);
        frame_allocator = std.heap.FixedBufferAllocator.init(frame_buffer.?);
    }
    
    assets_allocator = config.assets_allocator;
    try assets.init(assets_allocator);

    backend_allocator = config.backend_allocator;

    is_init = true;
}

pub fn deinit() void {
    // Cleanup assets
    assets.deinit();

    // Cleanup assets memory use default assets allocator
    if (std.meta.eql(assets_allocator, default_assets_allocator)) {
        const assets_leaked = default_assets_allocator_heap.deinit();
        if (assets_leaked) {
            @panic("Assets Leaked!");
        }
    }

    // Cleanup frame buffer if use default frame buffer
    if (frame_buffer) |buffer| {
        std.heap.page_allocator.free(buffer);
        frame_buffer = null;
    }

    raylib.CloseAudioDevice();
    raylib.CloseWindow();
    is_init = false;
}

pub fn isInit() bool {
    return is_init;
}

pub fn isClosing() bool {
    // Reset frame buffer
    frame_allocator.reset();

    return raylib.WindowShouldClose();
}

pub fn getDeltaTime() f32 {
    return raylib.GetFrameTime();
}

pub fn getTotalTime() f64 {
    return raylib.GetTime();
}

pub fn getFrameAllocator() std.mem.Allocator {
    return frame_allocator.allocator();
}

// For backends

// export fn backendAlloc(size: usize) ?[*]u8 {
//     const buffer = backend_allocator.alloc(u8, size) catch {
//         return null;
//     };

//     return buffer.ptr;
// }

// export fn backendFree(memory: ?[*]u8) void {
//     backend_allocator.free(memory);
// }

// export fn backendCalloc(nitems: usize, size: usize) callconv(.C) ?[*]u8 {
//     const buffer_size = nitems * size;
//     if (backendAlloc(buffer_size)) |buffer| {
//         return buffer;
//     } else {
//         return null;
//     }
// }

// export fn backendRealloc(old_mem: ?[*]u8, new_n: usize) callconv(.C) ?[*]u8 {
//     const buffer = backend_allocator.realloc(old_mem, new_n) catch {
//         return null;
//     };

//     return buffer.ptr;
// }