const std = @import("std");
const log = @import("log.zig");
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

var backend_allocator: ?std.mem.Allocator               = null;
var backend_allocations: ?std.AutoHashMap(usize, usize) = null;


// Native bindings

comptime {
    @import("meta/calloc.zig").wrapAllocator(struct {
        pub fn getAllocator(self: @This()) std.mem.Allocator {
            _ = self;
            return std.heap.c_allocator;
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
    
    // Prepairing allocators

    backend_allocator = config.backend_allocator;
    backend_allocations = std.AutoHashMap(usize, usize).init(config.backend_allocator);
    try backend_allocations.?.ensureTotalCapacity(16);

    if (config.frame_buffer) |buffer| {
        frame_allocator = std.heap.FixedBufferAllocator.init(buffer);
    } else {
        const frame_buffer_size = 10 * 1024 * 1024;
        frame_buffer = try std.heap.page_allocator.alloc(u8, frame_buffer_size);
        frame_allocator = std.heap.FixedBufferAllocator.init(frame_buffer.?);
    }
    
    assets_allocator = config.assets_allocator;
    try assets.init(assets_allocator);

    // Init submodules

    raylib.InitWindow(config.width, config.height, @ptrCast([*c]const u8, config.title));
    if (!raylib.IsWindowReady()) {
        return error.FailedToInitWindow;
    }

    raylib.InitAudioDevice();
    if (!raylib.IsAudioDeviceReady()) {
        return error.FailedToInitAudio;
    }

    raylib.SetTargetFPS(config.framerate);
    //raylib.SetTraceLogLevel(raylib.LOG_DEBUG);

    is_init = true;
}

pub fn deinit() void {
    // Deinit submodules
    raylib.CloseAudioDevice();
    raylib.CloseWindow();

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

    // Cleanup backend allocations
    if (backend_allocator) |allocator| {
        backend_allocations.?.deinit();
        backend_allocations = null;

        if (std.meta.eql(allocator, default_backend_allocator)) {
            const backend_leaked = default_backend_allocator_heap.deinit();
            if (backend_leaked) {
                @panic("Backends Leaked!");
            }
        }
    }

    // Done.
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

// Allocator

pub fn getFrameAllocator() std.mem.Allocator {
    return frame_allocator.allocator();
}

pub fn getAssetsAllocator() std.mem.Allocator {
    return assets_allocator;   
}

// For backends

export fn gamefxBackendMalloc(size: usize) callconv(.C) ?*anyopaque {
    const buffer = backend_allocator.?.alignedAlloc(u8, 16, size) catch {
        @panic("Backend: out of memory");
        //return null;
    };

    backend_allocations.?.put(@ptrToInt(buffer.ptr), size) catch @panic("Backend: out of memory");
    return buffer.ptr;
}

export fn gamefxBackendFree(maybe_ptr: ?*anyopaque) callconv(.C) void {
    if (maybe_ptr) |ptr| {
        const size = backend_allocations.?.fetchRemove(@ptrToInt(ptr)).?.value;
        const buffer = @ptrCast([*]align(16) u8, @alignCast(16, ptr))[0..size];
        backend_allocator.?.free(buffer);
    }
}

export fn gamefxBackendCalloc(nitems: usize, size: usize) callconv(.C) ?*anyopaque {
    const buffer_size = nitems * size;
    if (gamefxBackendMalloc(buffer_size)) |buffer| {
        return buffer;
    } else {
        return null;
    }
}

export fn gamefxBackendRealloc(ptr: ?*anyopaque, size: usize) callconv(.C) ?*anyopaque {
    const old_size = if (ptr != null) backend_allocations.?.get(@ptrToInt(ptr.?)).? else 0;
    const old_mem = if (old_size > 0)
        @ptrCast([*]align(16) u8, @alignCast(16, ptr))[0..old_size]
    else
        @as([*]align(16) u8, undefined)[0..0];

    const new_mem = backend_allocator.?.realloc(old_mem, size) catch @panic("Backend: out of memory");

    if (ptr != null) {
        const removed = backend_allocations.?.remove(@ptrToInt(ptr.?));
        std.debug.assert(removed);
    }

    backend_allocations.?.put(@ptrToInt(new_mem.ptr), size) catch @panic("Backend: out of memory");

    return new_mem.ptr;
}