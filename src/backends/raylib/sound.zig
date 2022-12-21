pub const raylib = @import("../raylib.zig");

// Types

const Wave          = @import("wave.zig");
const Sound         = @This();
const AudioStream   = @import("audio_stream.zig");

// Fields

stream: AudioStream,            // Buffer data pointer
frame_count: u32,               // Total number of frames (considering channels)
volume: f32,                    // 
pitch: f32,                     //
pan: f32,                       //

// Methods

pub fn init(args: anytype) !Wave {
    const T = @TypeOf(args);
    const backend_sound = switch (T) {
        []const u8      => raylib.LoadSound(@ptrCast([*c]const u8, args)),
        [*c]const u8    => raylib.LoadSound(args),

        Wave            => raylib.LoadSoundFromWave(args.asBackendType()),
        *Wave           => raylib.LoadSoundFromWave(args.asBackendType()),
        *const Wave     => raylib.LoadSoundFromWave(args.asBackendType()),

        raylib.Wave     => raylib.LoadSoundFromWave(args),

        raylib.Sound    => args,

        else => {
            @compileError("Sound.init() is not implement for " ++ @typeName(T));
        }
    };

    if (backend_sound.data == null) {
        return error.InitFailed;
    }

    return fromBackendType(backend_sound);
}

pub fn deinit(sound: *Sound) void {
    raylib.UnloadSound(sound.asBackendType());

    sound.* = .{
        .stream = .{
            .buffer         = null,
            .processor      = null,
            .sample_rate    = 0,
            .sample_size    = 0,
            .channels       = 0
        },
        .frame_count        = 0,
        .volume             = 0,
        .pitch              = 0,
        .pan                = 0,
    };
}

pub fn play(sound: *Sound) void {
    raylib.PlaySound(sound.asBackendType());
}

pub fn stop(sound: *Sound) void {
    raylib.StopSound(sound.asBackendType());
}

pub fn playMulti(sound: *Sound) void {
    raylib.PlaySoundMulti(sound.asBackendType());
}

pub fn stopMulti(sound: *Sound) void {
    raylib.StopSoundMulti(sound.asBackendType());
}

pub fn pause(sound: *Sound) void {
    raylib.PauseSound(sound.asBackendType());
}

pub fn resume(sound: *Sound) void {
    raylib.ResumeSound(sound.asBackendType());
}

pub fn isPlaying(sound: *const Sound) bool {
    return raylib.IsSoundPlaying(sound.asBackendType());
}

pub fn setVolume(sound: *Sound, volume: f32) void {
    raylib.SetSoundVolume(sound.asBackendType(), @floatCast(c_float, volume));
    sound.volume = volume;
}

pub fn setPitch(sound: *Sound, pitch: f32) void {
    raylib.SetSoundPitch(sound.asBackendType(), @floatCast(c_float, pitch));
    sound.pitch = pitch;
}

pub fn setPan(sound: *Sound, pan: f32) void {
    raylib.SetSoundPan(sound.asBackendType(), @floatCast(c_float, pan));
    sound.pan = pan;
}

// Helper to work with backend

pub inline fn fromBackendType(backend_sound: raylib.Sound) Sound {
    return .{ 
        .stream = .{
            .buffer         = backend_sound.stream.buffer,
            .processor      = backend_sound.stream.processor,

            .sample_rate    = @intCast(u32, backend_sound.stream.sampleRate),
            .sample_size    = @intCast(u32, backend_sound.stream.sampleSize),
            .channels       = @intCast(u32, backend_sound.stream.channels)
        },
        .frame_count        = @intCast(u32, backend_sound.frameCount),
        .volume             = 1.0,  // Default value of raudio's sound
        .pitch              = 1.0,  // Default value of raudio's sound
        .pan                = 0.5,  // Default value of raudio's sound
    };
}

pub inline fn asBackendType(sound: *const Sound) raylib.Sound {
    @setRuntimeSafety(false);
    defer @setRuntimeSafety(true);
    
    return .{
        .stream = .{
            .buffer         = sound.stream.buffer,
            .processor      = sound.stream.processor,

            .sampleRate     = @intCast(c_uint, sound.stream.sample_rate),
            .sampleSize     = @intCast(c_uint, sound.stream.sample_size),
            .channels       = @intCast(c_uint, sound.stream.channels)
        },
        .frameCount         = @intCast(c_uint, sound.frame_count),
    };
}