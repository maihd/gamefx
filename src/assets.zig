const types = @import("types.zig");
const raylib = @import("backends/raylib.zig");

pub fn loadTexture(path: []const u8) !types.Texture {
    const texture = raylib.LoadTexture(@ptrCast([*c]const u8, path));
    return if (texture.id == 0) error.FileNotExists else texture;
}

pub fn unloadTexture(texture: types.Texture) void {
    raylib.UnloadTexture(texture);
}