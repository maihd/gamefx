const raylib = @import("backends/raylib.zig");
const types = @import("types.zig");

// Keyboard

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

// Mouse

pub fn isMouseUp(button: types.MouseButton) bool {
    return raylib.IsMouseButtonUp(@enumToInt(button));
}

pub fn isMouseDown(button: types.MouseButton) bool {
    return raylib.IsMouseButtonDown(@enumToInt(button));
}

pub fn isMousePressed(button: types.MouseButton) bool {
    return raylib.IsMouseButtonPressed(@enumToInt(button));
}

pub fn isMouseReleased(button: types.MouseButton) bool {
    return raylib.IsMouseButtonReleased(@enumToInt(button));
}

pub fn getMouseX() f32 {
    var position = raylib.GetMousePosition();
    return position.x;
}

pub fn getMouseY() f32 {
    var position = raylib.GetMousePosition();
    return position.y;
}

pub fn getMouseDelta() types.f32x2 {
    var delta = raylib.GetMouseDelta();
    return .{ delta.x, delta.y };
}

pub fn getMouseWheel() types.f32x2 {
    var wheel = raylib.GetMouseWheelMoveV();
    return .{ wheel.x, wheel.y };
}

pub fn getMousePosition() types.f32x2 {
    var position = raylib.GetMousePosition();
    return .{ position.x, position.y };
}

pub fn setMouseScale(scale: types.f32x2) void {
    raylib.SetMouseScale(scale[0], scale[1]);
}

pub fn setMouseOffset(offset: types.f32x2) void {
    raylib.SetMouseOffset(@floatToInt(c_int, offset[0]), @floatToInt(c_int, offset[1]));
}

pub fn setMousePosition(position: types.f32x2) void {
    raylib.SetMousePosition(@floatToInt(c_int, position[0]), @floatToInt(c_int, position[1]));
}

pub fn setMouseCursor(cursor: types.MouseCursor) void {
    raylib.SetMouseCursor(@enumToInt(cursor));
}