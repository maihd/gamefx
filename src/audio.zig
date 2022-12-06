const raylib = @import("backends/raylib.zig");
const types = @import("types.zig");

pub fn setMasterVolume(volume: f32) void {
    raylib.SetMasterVolume(volume);
}

pub fn playSound(sound: types.Sound) void {
    raylib.PlaySound(sound);
}

pub fn stopSound(sound: types.Sound) void {
    raylib.StopSound(sound);
}

pub fn playMusic(music: types.Music) void {
    raylib.PlayMusic(music);
}

pub fn stopMusic(music: types.Music) void {
    raylib.StopMusic(music);
}

pub fn updateMusic(music: types.Music) void {
    raylib.UpdateMusic(music);
}