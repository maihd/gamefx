pub const raylib = @import("../raylib.zig");

// Types

const Image = @import("image.zig");
const Texture = @This();
const PixelFormat = @import("pixel_format.zig").PixelFormat;

pub const Filter = enum(u32) {
    point = 0,                  // No filter, just pixel approximation
    bilinear,                   // Linear filtering
    trilinear,                  // Trilinear filtering (linear with mipmaps)
    anisotropic_4x,             // Anisotropic filtering 4x
    anisotropic_8x,             // Anisotropic filtering 8x
    anisotropic_16x,            // Anisotropic filtering 16x
};

pub const Wrap = enum(u32) {
    repeat = 0,                 // Repeats texture in tiled mode
    clamp,                      // Clamps texture to edge pixel in tiled mode
    mirror_repeat,              // Mirrors and repeats the texture in tiled mode
    mirror_clamp 
};

// Fields

id: u32,
width: u32,
height: u32,
mipmaps: u32,
pixel_format: PixelFormat,

filter: Filter  = .point,
wrap: Wrap      = .repeat,

// Methods

pub fn init(args: anytype) !Texture {
    const T = @TypeOf(args);
    const backend_texture = switch (T) {
        []const u8      => raylib.LoadTexture(@ptrCast([*c]const u8, args)),
        [*c]const u8    => raylib.LoadTexture(args),

        Image           => raylib.LoadTextureFromImage(args.asBackendType()),
        *Image          => raylib.LoadTextureFromImage(args.asBackendType()),
        *const Image    => raylib.LoadTextureFromImage(args.asBackendType()),

        raylib.Image    => raylib.LoadTextureFromImage(args),
        raylib.Texture  => args,

        else => {
            @compileError("Texture.init() is not implement for " ++ @typeName(T));
        }
    };

    if (backend_texture.id == 0) {
        return error.CreateFailed;
    }

    var texture = fromBackendType(backend_texture);

    // Ensure default properties
    texture.setFilter(texture.filter);
    texture.setWrap(texture.wrap);

    return texture;
}

pub fn deinit(texture: *Texture) void {
    raylib.UnloadTexture(texture.asBackendType());

    texture.* = .{
        .id             = 0,
        .width          = 0,
        .height         = 0,
        .mipmaps        = 0,
        .pixel_format   = .none,
    };
}

pub fn update(texture: *Texture, pixels: []const u8) void {
    raylib.UpdateTexture(texture.asBackendType(), @ptrCast(*const anyopaque, pixels));
}

pub fn updateRect(texture: *Texture, pixels: []const u8, rect: @Vector(4, f32)) void {
    raylib.UpdateTexture(texture.asBackendType(), raylib.toRectangle(rect), @ptrCast(*const anyopaque, pixels));
}

pub fn genMipmaps(texture: *Texture) void {
    var backend_texture = texture.asBackendType();
    raylib.GenTextureMipmaps(&backend_texture);

    texture.mipmaps = @intCast(u32, backend_texture.mipmaps);
}

pub fn setFilter(texture: *Texture, filter: Filter) void {
    raylib.SetTextureFilter(texture.asBackendType(), @intCast(c_int, @enumToInt(filter)));
    texture.*.filter = filter;
}

pub fn setWrap(texture: *Texture, wrap: Wrap) void {
    raylib.SetTextureWrap(texture.asBackendType(), @intCast(c_int, @enumToInt(wrap)));
    texture.*.wrap = wrap;
}

// Helper to work with backend

pub inline fn fromBackendType(backend_texture: raylib.Texture) Texture {
    return .{ 
        .id             = @intCast(u32, backend_texture.id),
        .width          = @intCast(u32, backend_texture.width),
        .height         = @intCast(u32, backend_texture.height),
        .mipmaps        = @intCast(u32, backend_texture.mipmaps),
        .pixel_format   = @intToEnum(PixelFormat, backend_texture.format)
    };
}

pub inline fn asBackendType(texture: *const Texture) raylib.Texture {
    @setRuntimeSafety(false);
    defer @setRuntimeSafety(true);

    return .{
        .id             = @intCast(c_uint, texture.id),
        .width          = @intCast(c_int, texture.width),
        .height         = @intCast(c_int, texture.height),
        .mipmaps        = @intCast(c_int, texture.mipmaps),
        .format         = @intCast(c_int, @enumToInt(texture.pixel_format))
    };
}