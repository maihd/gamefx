const std = @import("std");
const text = @import("text.zig");
const types = @import("types.zig");
const raylib = @import("backends/raylib.zig");

// Manage assets

var search_paths: std.ArrayList([]u8)       = undefined;
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
    var file = std.fs.cwd().openFile(path, .{ .mode = .read_only }) catch {
        for (search_paths.items) |search_path| {
            const file_path = text.format("{s}/{s}", .{ search_path, path }) catch {
                continue;
            };

            const file = std.fs.openFileAbsolute(file_path, .{ .mode = .read_only }) catch {
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
        const file = std.fs.openFileAbsolute(file_path, .{ .mode = .read_only }) catch {
            return null;
        };
        defer file.close();

        const stat = file.stat() catch {
            return null;
        };

        var buffer = allocator.alloc(u8, @as(usize, stat.size)) catch { 
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

// Manage audio

pub fn loadSound(path: []const u8) !types.Sound {
    if (getExistsFilePath(path)) |file_path| {
        const sound = raylib.LoadSound(@ptrCast([*c]const u8, file_path));
        return if (sound.stream.buffer == null) error.FileNotFound else sound;
    } else {
        return error.AssetsNotFound;
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
        return error.AssetsNotFound;
    }
}

pub fn unloadMusic(music: types.Music) void {
    raylib.UnloadMusicStream(music);
}

// Manage shader

// Manage texture

pub fn loadImage(path: []const u8) !types.Image {
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

pub fn unloadImage(image: types.Image) void {
    raylib.UnloadImage(image);
}

pub fn loadTexture(path: []const u8) !types.Texture {
    const image = try loadImage(path);
    defer unloadImage(image);

    const texture = raylib.LoadTextureFromImage(image);
    return if (texture.id == 0) error.CreateFailed else texture;
}

pub fn unloadTexture(texture: types.Texture) void {
    raylib.UnloadTexture(texture);
}