pub const raylib = @import("../raylib.zig");

// Types

pub const Image = @This();
pub const PixelFormat = @import("pixel_format.zig").PixelFormat;

// Fields

data: ?*anyopaque,
width: u32,
height: u32,
mipmaps: u32,
pixel_format: PixelFormat,

// Methods

pub fn init(path: []const u8) !Image {
    const backend_image = raylib.LoadImage(@ptrCast([*c]const u8, path));
    if (backend_image.data == null) {
        return error.CreateFailed;
    }

    return fromBackendType(backend_image);
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

pub fn deinit(image: *Image) void {
    raylib.UnloadImage(image.asBackendType());

    image.* = .{
        .data           = null,
        .width          = 0,
        .height         = 0,
        .mipmaps        = 0,
        .pixel_format   = .none
    };
}

// Helper to work with backend

pub fn fromBackendType(backend_image: raylib.Image) Image {
    return .{ 
        .data           = backend_image.data,
        .width          = @intCast(u32, backend_image.width),
        .height         = @intCast(u32, backend_image.height),
        .mipmaps        = @intCast(u32, backend_image.mipmaps),
        .pixel_format   = @intToEnum(PixelFormat, backend_image.format)
    };
}

pub fn asBackendType(image: *const Image) raylib.Image {
    return .{
        .id             = @intCast(i32, image.id),
        .width          = @intCast(i32, image.width),
        .height         = @intCast(i32, image.height),
        .mipmaps        = @intCast(i32, image.mipmaps),
        .pixel_format   = @intToEnum(PixelFormat, image.pixel_format)
    };
}