pub const raylib = @import("../raylib.zig");

// Types

pub const Wave = @This();

// Fields

data: ?*anyopaque,              // Buffer data pointer
frame_count: u32,               // Total number of frames (considering channels)
sample_rate: u32,               // Frequency (samples per second)
sample_size: u32,               // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
channels: u32,                  // Number of channels (1-mono, 2-stereo, ...)

// Methods

pub fn init(args: anytype) !Wave {
    const T = @TypeOf(args);
    const backend_wave = switch (T) {
        []const u8      => raylib.LoadWave(@ptrCast([*c]const u8, args)),
        [*c]const u8    => raylib.LoadWave(args),
        raylib.Wave     => args,

        else => {
            @compileError("Wave.init() is not implement for " ++ @typeName(T));
        }
    };

    if (backend_wave.data == null) {
        return error.InitFailed;
    }

    return fromBackendType(backend_wave);
}

pub fn deinit(wave: *Wave) void {
    raylib.UnloadWave(wave.asBackendType());

    wave.* = .{
        .data           = null,
        .frame_count    = 0,
        .sample_rate    = 0,
        .sample_size    = 0,
        .channels       = 0
    };
}

// Helper to work with backend

pub inline fn fromBackendType(backend_wave: raylib.Wave) Wave {
    return .{ 
        .data           = backend_wave.data,
        .frame_count    = @intCast(u32, backend_wave.frameCount),
        .sample_rate    = @intCast(u32, backend_wave.sampleRate),
        .sample_size    = @intCast(u32, backend_wave.sampleSize),
        .channels       = @intCast(u32, backend_wave.channels)
    };
}

pub inline fn asBackendType(wave: *const Wave) raylib.Wave {
    @setRuntimeSafety(false);
    defer @setRuntimeSafety(true);
    
    return .{
        .data           = wave.data,
        .frameCount     = @intCast(c_uint, wave.frame_count),
        .sampleRate     = @intCast(c_uint, wave.sample_rate),
        .sampleSize     = @intCast(c_uint, wave.sample_size),
        .channels       = @intCast(c_uint, wave.channels)
    };
}