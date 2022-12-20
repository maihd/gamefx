pub const raylib = @import("../raylib.zig");

// Types

pub const Texture = @This();
pub const PixelFormat = @import("pixel_format.zig");

// Fields

id: u32,
width: u32,
height: u32,
mipmaps: u32,
pixel_format: PixelFormat,

// Methods

pub fn init(path: []const u8) !Texture {
    const backend_texture = raylib.LoadTexture(@ptrCast([*c]const u8, path));
    if (backend_texture.id == 0) {
        return error.CreateFailed;
    }

    return fromBackendType(backend_texture);
}

//pub fn init(pixels: []const u8, width: i32, height: i32, mimmaps: i32, pixel_format: PixelFormat) !Texture {
//    if (pixels.len > 0) {
//        return .{ 
//            .id             = 0,
//            .width          = width,
//            .height         = height,
//            .mipmaps        = mipmaps,
//            .pixel_format   = pixel_format
//        };
//    }
//
//    return error.CreateFailed;
//}

pub fn deinit(self: *Self) void {
    raylib.UnloadTexture();

    self.* = .{
        .id             = 0,
        .width          = 0,
        .height         = 0,
        .mipmaps        = 0,
        .pixel_format   = .none
    };
}

// Helper to work with backend

pub fn fromBackendType(backend_texture: raylib.Texture) Texture {
    return .{ 
        .id             = @intCast(u32, backend_texture.id),
        .width          = @intCast(u32, backend_texture.width),
        .height         = @intCast(u32, backend_texture.height),
        .mipmaps        = @intCast(u32, backend_texture.mipmaps),
        .pixel_format   = @intToEnum(PixelFormat, backend_texture.format)
    };
}

pub fn asBackendType(self: *const Self) raylib.Texture {
    return .{
        .id             = @intCast(i32, self.id),
        .width          = @intCast(i32, self.width),
        .height         = @intCast(i32, self.height),
        .mipmaps        = @intCast(i32, self.mipmaps),
        .pixel_format   = @intToEnum(PixelFormat, self.pixel_format)
    };
}