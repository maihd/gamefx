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
    raylib.PlayMusicStream(music);
}

pub fn stopMusic(music: types.Music) void {
    raylib.StopMusicStream(music);
}

pub fn pauseMusic(music: types.Music) void {
    raylib.PauseMusicStream(music);
}

pub fn resumeMusic(music: types.Music) void {
    raylib.ResumeMusicStream(music);
}

pub fn updateMusic(music: types.Music) void {
    raylib.UpdateMusicStream(music);
}

pub fn isMusicPlaying(music: types.Music) void {
    raylib.IsMusicStreamPlaying(music);
}