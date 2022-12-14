const std = @import("std");
const text = @import("text.zig");
const types = @import("types.zig");
const raylib = @import("backends/raylib.zig");

// Types

const Font      = types.Font;

const Wave      = types.Wave;
const Sound     = types.Sound;
const Music     = types.Music;

const Image     = types.Image;
const Texture   = types.Texture;

// Manage assets

var assets_allocator: std.mem.Allocator         = undefined;

var search_paths: std.ArrayList([]u8)           = undefined;

var wave_cache: std.StringHashMap(Wave)         = undefined;
var texture_cache: std.StringHashMap(Texture)   = undefined;

pub fn init(allocator: std.mem.Allocator) !void {
    assets_allocator = allocator;

    search_paths = std.ArrayList([]u8).init(allocator);

    wave_cache = std.StringHashMap(Wave).init(allocator);
    texture_cache = std.StringHashMap(Texture).init(allocator);
}

pub fn deinit() void {
    texture_cache.deinit();
    wave_cache.deinit();

    search_paths.deinit();
}

pub fn addSearchPath(path: []const u8) !void {
    // Check if search path is a directory
    _ = try std.fs.openDirAbsolute(path, .{});
    
    // Storing
    const storing_path = try assets_allocator.dupe(u8, path);
    try search_paths.append(storing_path);
}

pub fn removeSearchPath(path: []const u8) void {
    const found_index =  for (search_paths.items) |search_path, index| {
        if (std.mem.eql(u8, search_path, path)) break index;
    } else null;
    
    if (found_index) |index| {
        const storing_path = search_paths.orderedRemove(index);
        assets_allocator.free(storing_path);
    }
}

pub fn getExistsFilePath(path: []const u8) ?[]const u8 {
    const cwd = std.fs.cwd();

    const file = cwd.openFile(path, .{ .mode = .read_only }) catch {
        for (search_paths.items) |search_path| {
            const file_path = text.format("{s}/{s}", .{ search_path, path }) catch {
                continue;
            };

            const file = cwd.openFile(file_path, .{ .mode = .read_only }) catch {
                continue;
            };
            defer file.close();

            return file_path;
        }
        
        return null;
    };

    file.close();
    return path;
}

pub fn getData(allocator: std.mem.Allocator, path: []const u8) ?[]u8 {
    if (getExistsFilePath(path)) |file_path| {
        const file = std.fs.cwd().openFile(file_path, .{ .mode = .read_only }) catch {
            return null;
        };
        defer file.close();

        const stat = file.stat() catch {
            return null;
        };

        const buffer = allocator.alloc(u8, @as(usize, stat.size)) catch { 
            return null;
        };
        
        const read_bytes = file.readAll(buffer) catch { 
            return null;
        };

        return buffer[0..read_bytes];
    } else {
        return null;
    }
}

// Utils

// Manage font

pub fn loadFont(path: []const u8) !Font {
    if (getExistsFilePath(path)) |file_path| {
        const font = raylib.LoadFont(@ptrCast([*c]const u8, file_path));
        return if (font.texture.id == 0) error.DecodeFailed else font;
    } else {
        return error.AssetsNotFound;
    }
}

pub fn unloadFont(font: Font) void {
    raylib.UnloadFont(font);
}

// Manage audio

pub fn loadWave(path: []const u8) Wave {
    if (getExistsFilePath(path)) |file_path| {
        if (wave_cache.get(file_path)) |wave| {
            return wave;
        }

        const wave = raylib.LoadWave(@ptrCast([*c]const u8, file_path));
        return if (wave.data == null) error.DecodeFailed else wave;
    } else {
        return error.AssetsNotFound;
    }
}

pub fn unloadWave(wave: Wave) void {
    var iterator = wave_cache.iterator();
    while (iterator.next()) |entry| {
        if (entry.value_ptr.data == wave.data) {
            texture_cache.removeByPtr(entry.key_ptr);
            break;
        }
    }

    raylib.UnloadWave(wave);
}

pub fn loadSound(path: []const u8) !Sound {
    const wave = try loadWave(path);
    // no unload here, wave is cached

    const sound = raylib.LoadSoundFromWave(wave);
    return if (sound.stream.buffer == null) error.CreateFailed else sound;
}

pub fn unloadSound(sound: Sound) void {
    raylib.UnloadSound(sound);
}

pub fn loadMusic(path: []const u8) !Music {
    if (getExistsFilePath(path)) |file_path| {
        const music = raylib.LoadMusicStream(@ptrCast([*c]const u8, file_path));
        return if (music.stream.buffer == null) error.DecodeFailed else music;
    } else {
        return error.AssetsNotFound;
    }
}

pub fn unloadMusic(music: Music) void {
    raylib.UnloadMusicStream(music);
}

// Manage shader

// Manage texture

pub fn loadImage(path: []const u8) !Image {
    if (getData(assets_allocator, path)) |data| {
        defer assets_allocator.free(data);

        const extension = @ptrCast([*c]const u8, std.fs.path.extension(path));
        const image = raylib.LoadImageFromMemory(extension, data.ptr, @intCast(c_int, data.len));
        if (image.data == null) {
            return error.DecodeFailed;
        } else {
            return image;
        }
    } else {
        return error.AssetsNotFound;
    }
}

pub fn unloadImage(image: Image) void {
    raylib.UnloadImage(image);
}

pub fn loadTexture(path: []const u8) !Texture {
    if (getExistsFilePath(path)) |file_path| {
        if (texture_cache.get(file_path)) |texture| {
            return texture;
        }

        const texture = raylib.LoadTexture(@ptrCast([*c]const u8, file_path));
        if (texture.id == 0) {
            return error.CreateFailed;
        }

        try texture_cache.put(file_path, texture);
        return texture;
    } else {
        return error.AssetsNotFound;
    }
}

pub fn unloadTexture(texture: Texture) void {
    var iterator = texture_cache.iterator();
    while (iterator.next()) |entry| {
        if (entry.value_ptr.id == texture.id) {
            texture_cache.removeByPtr(entry.key_ptr);
            break;
        }
    }

    raylib.UnloadTexture(texture);
}