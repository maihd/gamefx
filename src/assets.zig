const std = @import("std");
const text = @import("text.zig");
const types = @import("types.zig");
const raylib = @import("backends/raylib.zig");

// Manage assets

var search_paths: std.ArrayList([]u8) = undefined;
var assets_allocator: std.mem.Allocator     = undefined;

pub fn init(allocator: std.mem.Allocator) !void {
    search_paths = std.ArrayList([]u8).init(allocator);
    assets_allocator = allocator;
}

pub fn deinit() void {
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
    var file = std.fs.openFileAbsolute(path, .{ .mode = .read_only }) catch {
        for (search_paths.items) |search_path| {
            const file_path = text.format("{s}/{s}", .{ search_path, path }) catch {
                continue;
            };

            var file = std.fs.openFileAbsolute(file_path, .{ .mode = .read_only }) catch {
                continue;
            };

            file.close();
            return file_path;
        }
        
        return null;
    };

    file.close();
    return path;
}

// Manage font

// Manage audio

pub fn loadSound(path: []const u8) !types.Sound {
    if (getExistsFilePath(path)) |file_path| {
        const sound = raylib.LoadSound(@ptrCast([*c]const u8, file_path));
        return if (sound.stream.buffer == null) error.FileNotFound else sound;
    } else {
        return error.FileNotFound;
    }
}

pub fn unloadSound(sound: types.Sound) void {
    raylib.UnloadSound(sound);
}

pub fn loadMusic(path: []const u8) !types.Music {
    if (getExistsFilePath(path)) |file_path| {
        const music = raylib.LoadMusicStream(@ptrCast([*c]const u8, file_path));
        return if (music.stream.buffer == null) error.FileNotFound else music;
    } else {
        return error.FileNotFound;
    }
}

pub fn unloadMusic(music: types.Music) void {
    raylib.UnloadMusicStream(music);
}

// Manage shader

// Manage texture

pub fn loadTexture(path: []const u8) !types.Texture {
    if (getExistsFilePath(path)) |file_path| {
        const texture = raylib.LoadTexture(@ptrCast([*c]const u8, file_path));
        return if (texture.id == 0) error.FileNotFound else texture;
    } else {
        return error.FileNotFound;
    }
}

pub fn unloadTexture(texture: types.Texture) void {
    raylib.UnloadTexture(texture);
}