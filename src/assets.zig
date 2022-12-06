const types = @import("types.zig");
const raylib = @import("backends/raylib.zig");

// Manage font

// Manage audio

pub fn loadSound(path: []const u8) !types.Sound {
    const sound = raylib.LoadSound(@ptrCast([*c]const u8, path));
    return if (sound.stream.buffer == null) error.FileNotFound else sound;
}

pub fn unloadSound(sound: types.Sound) void {
    raylib.UnloadSound(sound);
}

pub fn loadMusic(path: []const u8) !types.Music {
    const music = raylib.LoadSound(@ptrCast([*c]const u8, path));
    return if (music.stream.buffer == null) error.FileNotFound else music;
}

pub fn unloadMusic(music: types.Music) void {
    raylib.UnloadMusic(music);
}

// Manage shader

// Manage texture

pub fn loadTexture(path: []const u8) !types.Texture {
    const texture = raylib.LoadTexture(@ptrCast([*c]const u8, path));
    return if (texture.id == 0) error.FileNotFound else texture;
}

pub fn unloadTexture(texture: types.Texture) void {
    raylib.UnloadTexture(texture);
}