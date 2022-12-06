const std = @import("std");
const raylib = @import("backends/raylib.zig");

var is_init = false;

var frame_buffer: ?[]u8 = null;
var frame_allocator: std.heap.FixedBufferAllocator = undefined;

pub const Config = struct {
    title: []const u8,
    width: i32,
    height: i32,
    framerate: i32 = 60,

    frame_buffer_size: u32 = 10 * 1024 * 1024,
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

    if (config.frame_buffer_size == 0) {
        return error.FrameBufferSizeInvalid;
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

    frame_buffer = try std.heap.page_allocator.alloc(u8, config.frame_buffer_size);
    frame_allocator = std.heap.FixedBufferAllocator.init(frame_buffer.?);

    is_init = true;
}

pub fn deinit() void {
    std.heap.page_allocator.free(frame_buffer.?);
    frame_buffer = null;

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