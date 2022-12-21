pub const raylib = @import("../raylib.zig");

// Types

const AudioStream = @This();

// Fields

buffer: ?*raylib.rAudioBuffer,          // Pointer to internal data used by the audio system
processor: ?*raylib.rAudioProcessor,    // Pointer to internal data processor, useful for audio effects

sample_rate: u32,               // Frequency (samples per second)
sample_size: u32,               // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
channels: u32,                  // Number of channels (1-mono, 2-stereo, ...)

// Methods

pub fn init(sample_rate: u32, sample_size: u32, channels: u32) !AudioStream {
    const backend_audio_stream = raylib.LoadAudioStream(
        @intCast(c_uint, sample_rate),
        @intCast(c_uint, sample_size),
        @intCast(c_uint, channels)
    );

    if (backend_audio_stream.buffer == null or backend_audio_stream.processor == null) {
        return error.InitFailed;
    }

    return fromBackendType(backend_audio_stream);
}

pub fn deinit(audio_stream: *AudioStream) void {
    raylib.UnloadAudioStream(audio_stream.asBackendType());

    audio_stream.* = .{
        .buffer         = null,
        .processor      = null,
        .sample_rate    = 0,
        .sample_size    = 0,
        .channels       = 0
    };
}

pub fn play(audio_stream: *AudioStream) void {
    raylib.PlayAudioStream(audio_stream.asBackendType());
}

pub fn stop(audio_stream: *AudioStream) void {
    raylib.StopAudioStream(audio_stream.asBackendType());
}

pub fn pause(audio_stream: *AudioStream) void {
    raylib.PauseAudioStream(audio_stream.asBackendType());
}

pub fn resume(audio_stream: *AudioStream) void {
    raylib.ResumeAudioStream(audio_stream.asBackendType());
}

pub fn update(audio_stream: *AudioStream) void {
    raylib.UpdateAudioStream(audio_stream.asBackendType());
}

pub fn isPlaying(audio_stream: *const AudioStream) bool {
    return raylib.IsAudioStreamPlaying(audio_stream.asBackendType());
}

pub fn isProcessed(audio_stream: *const AudioStream) bool {
    return raylib.IsAudioStreamProcessed(audio_stream.asBackendType());
}

pub fn setVolume(audio_stream: *AudioStream, volume: f32) void {
    raylib.SetAudioStreamVolume(audio_stream.asBackendType(), @floatCast(c_float, volume));
    //audio_stream.volume = volume;
}

pub fn setPitch(audio_stream: *AudioStream, pitch: f32) void {
    raylib.SetAudioStreamPitch(audio_stream.asBackendType(), @floatCast(c_float, pitch));
    //audio_stream.pitch = pitch;
}

pub fn setPan(audio_stream: *AudioStream, pan: f32) void {
    raylib.SetAudioStreamPan(audio_stream.asBackendType(), @floatCast(c_float, pan));
    //audio_stream.pan = pan;
}

// Helper to work with backend

pub inline fn fromBackendType(backend_audio_stream: raylib.AudioStream) AudioStream {
    return .{ 
        .buffer         = backend_audio_stream.buffer,
        .processor      = backend_audio_stream.processor,

        .sample_rate    = @intCast(u32, backend_audio_stream.sampleRate),
        .sample_size    = @intCast(u32, backend_audio_stream.sampleSize),
        .channels       = @intCast(u32, backend_audio_stream.channels)
    };
}

pub inline fn asBackendType(audio_stream: *const AudioStream) raylib.AudioStream {
    @setRuntimeSafety(false);
    defer @setRuntimeSafety(true);
    
    return .{
        .buffer         = audio_stream.buffer,
        .processor      = audio_stream.processor,

        .sampleRate     = @intCast(c_uint, audio_stream.sample_rate),
        .sampleSize     = @intCast(c_uint, audio_stream.sample_size),
        .channels       = @intCast(c_uint, audio_stream.channels)
    };
}