// Types

pub const Texture = @This();
pub const PixelFormat = @import("pixel_format.zig");

// Fields

id: i32,
width: i32,
height: i32,
mipmaps: i32,
pixel_format: PixelFormat,

// Methods

pub fn init(pixels: []const u8, width: i32, height: i32, mimmaps: i32, pixel_format: PixelFormat) !Texture {
    if (pixels.len > 0) {
        return .{ 
            .id             = 0,
            .width          = width,
            .height         = height,
            .mipmaps        = mipmaps,
            .pixel_format   = pixel_format
        };
    }

    return error.CreateFailed;
}

pub fn deinit(self: *Self) void {
    _ = self;
}