pub const raylib = @import("../raylib.zig");

// Types

const Image = @This();
const PixelFormat = @import("pixel_format.zig").PixelFormat;

// Fields

data: ?*anyopaque,
width: u32,
height: u32,
mipmaps: u32,
pixel_format: PixelFormat,

// Methods

pub fn init(args: anytype) !Image {
    const T = @TypeOf(args);
    const backend_image = switch (T) {
        []const u8      => raylib.LoadImage(@ptrCast([*c]const u8, args)),
        [*c]const u8    => raylib.LoadImage(args),
        raylib.Image    => args,

        else => {
            @compileError("Image.init() is not implement for " ++ @typeName(T));
        }
    };
    
    if (backend_image.data == null) {
        return error.InitFailed;
    }

    return fromBackendType(backend_image);
}

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

pub inline fn fromBackendType(backend_image: raylib.Image) Image {
    return .{ 
        .data           = backend_image.data,
        .width          = @intCast(u32, backend_image.width),
        .height         = @intCast(u32, backend_image.height),
        .mipmaps        = @intCast(u32, backend_image.mipmaps),
        .pixel_format   = @intToEnum(PixelFormat, backend_image.format)
    };
}

pub inline fn asBackendType(image: *const Image) raylib.Image {
    @setRuntimeSafety(false);
    defer @setRuntimeSafety(true);
    
    return .{
        .data           = image.data,
        .width          = @intCast(c_int, image.width),
        .height         = @intCast(c_int, image.height),
        .mipmaps        = @intCast(c_int, image.mipmaps),
        .format         = @intCast(c_int, @enumToInt(image.pixel_format))
    };
}