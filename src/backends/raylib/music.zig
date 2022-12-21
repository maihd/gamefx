pub const raylib = @import("../raylib.zig");

// Types

const Wave          = @import("wave.zig");
const Music         = @This();
const AudioStream   = @import("audio_stream.zig");

pub const ContextType = enum(u32) {
    audio_none = 0,   // No audio context loaded
    audio_wav,        // WAV audio context
    audio_ogg,        // OGG audio context
    audio_flac,       // FLAC audio context
    audio_mp3,        // MP3 audio context
    module_xm,        // XM module audio context
    module_mod        // MOD module audio context
};

// Fields

stream: AudioStream,            // Buffer data pointer
frame_count: u32,               // Total number of frames (considering channels)
looping: bool,                  // Music looping enable
ctx_type: ContextType,          // Type of music context (audio filetype)
ctx_data: ?*anyopaque,          // Audio context data, depends on type

volume: f32,                    // 
pitch: f32,                     //
pan: f32,                       //

// Methods

pub fn init(args: anytype) !Wave {
    const T = @TypeOf(args);
    const backend_music = switch (T) {
        []const u8      => raylib.LoadMusicStream(@ptrCast([*c]const u8, args)),
        [*c]const u8    => raylib.LoadMusicStream(args),
        raylib.Music    => args,

        else => {
            @compileError("Music.init() is not implement for " ++ @typeName(T));
        }
    };

    if (backend_music.data == null) {
        return error.InitFailed;
    }

    return fromBackendType(backend_music);
}

pub fn deinit(music: *Music) void {
    raylib.UnloadMusicStream(music.asBackendType());

    music.* = .{
        .stream = .{
            .buffer         = null,
            .processor      = null,
            .sample_rate    = 0,
            .sample_size    = 0,
            .channels       = 0
        },
        .frame_count        = 0,
        .looping            = false,
        .ctx_type           = .audio_none,
        .ctx_data           = null,
        .volume             = 0,
        .pitch              = 0,
        .pan                = 0,
    };
}

pub fn play(music: *Music) void {
    raylib.PlayMusicStream(music.asBackendType());
}

pub fn stop(music: *Music) void {
    raylib.StopMusicStream(music.asBackendType());
}

pub fn pause(music: *Music) void {
    raylib.PauseMusicStream(music.asBackendType());
}

pub fn resume(music: *Music) void {
    raylib.ResumeMusicStream(music.asBackendType());
}

pub fn update(music: *Music) void {
    raylib.UpdateMusicStream(music.asBackendType());
}

pub fn isPlaying(music: *const Music) bool {
    return raylib.IsMusicStreamPlaying(music.asBackendType());
}

pub fn setVolume(music: *Music, volume: f32) void {
    raylib.SetMusicVolume(music.asBackendType(), @floatCast(c_float, volume));
    music.volume = volume;
}

pub fn setPitch(music: *Music, pitch: f32) void {
    raylib.SetMusicPitch(music.asBackendType(), @floatCast(c_float, pitch));
    music.pitch = pitch;
}

pub fn setPan(music: *Music, pan: f32) void {
    raylib.SetMusicPan(music.asBackendType(), @floatCast(c_float, pan));
    music.pan = pan;
}

pub fn getTimeLength(music: *Music) f32 {
    return @floatCast(f32, raylib.GetMusicTimeLength(music.asBackendType()));
}

pub fn getTimePlayed(music: *Music) f32 {
    return @floatCast(f32, raylib.GetMusicTimePlayed(music.asBackendType()));
}

pub fn setTimePlayed(music: *Music, time: f32) void {
    raylib.SeekMusicStream(music.asBackendType(), @floatCast(f32, time));
}

// Helper to work with backend

pub inline fn fromBackendType(backend_music: raylib.Music) Music {
    return .{ 
        .stream = .{
            .buffer         = backend_music.stream.buffer,
            .processor      = backend_music.stream.processor,

            .sample_rate    = @intCast(u32, backend_music.stream.sampleRate),
            .sample_size    = @intCast(u32, backend_music.stream.sampleSize),
            .channels       = @intCast(u32, backend_music.stream.channels)
        },
        .frame_count        = @intCast(u32, backend_music.frameCount),
        .looping            = @as(bool, backend_music.looping),
        .ctx_type           = @intToEnum(ContextType, @intCast(u32, backend_music.ctxType)),
        .ctx_data           = backend_music.ctxData,
        .volume             = 1.0,  // Default value of raudio's music
        .pitch              = 1.0,  // Default value of raudio's music
        .pan                = 0.5,  // Default value of raudio's music
    };
}

pub inline fn asBackendType(music: *const Music) raylib.Music {
    @setRuntimeSafety(false);
    defer @setRuntimeSafety(true);
    
    return .{
        .stream = .{
            .buffer         = music.stream.buffer,
            .processor      = music.stream.processor,

            .sampleRate     = @intCast(c_uint, music.stream.sample_rate),
            .sampleSize     = @intCast(c_uint, music.stream.sample_size),
            .channels       = @intCast(c_uint, music.stream.channels)
        },
        .frameCount         = @intCast(c_uint, music.frame_count),
        .looping            = @as(bool, backend_music.looping),
        .ctx_type           = @intCast(c_int, @enumToInt(backend_music.ctxType)),
        .ctx_data           = backend_music.ctxData,
    };
}