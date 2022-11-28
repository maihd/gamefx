const raylib = @import("backends/raylib.zig");
const types = @import("types.zig");

pub fn isKeyUp(key: types.Key) bool {
    return raylib.IsKeyUp(@enumToInt(key));
}

pub fn isKeyDown(key: types.Key) bool {
    return raylib.IsKeyDown(@enumToInt(key));
}

pub fn isKeyPressed(key: types.Key) bool {
    return raylib.IsKeyPressed(@enumToInt(key));
}

pub fn isKeyReleased(key: types.Key) bool {
    return raylib.IsKeyReleased(@enumToInt(key));
}