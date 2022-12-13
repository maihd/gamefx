const raylib = @import("backends/raylib.zig");

const math = @import("math.zig");
const types = @import("types.zig");

// Types

const Key           = types.Key;
const Vec           = types.Vec;
const MouseButton   = types.MouseButton;
const MouseCursor   = types.MouseCursor;

// Keyboard

pub fn isKeyUp(key: Key) bool {
    return raylib.IsKeyUp(@enumToInt(key));
}

pub fn isKeyDown(key: Key) bool {
    return raylib.IsKeyDown(@enumToInt(key));
}

pub fn isKeyPressed(key: Key) bool {
    return raylib.IsKeyPressed(@enumToInt(key));
}

pub fn isKeyReleased(key: Key) bool {
    return raylib.IsKeyReleased(@enumToInt(key));
}

// Mouse

pub fn isMouseUp(button: MouseButton) bool {
    return raylib.IsMouseButtonUp(@enumToInt(button));
}

pub fn isMouseDown(button: MouseButton) bool {
    return raylib.IsMouseButtonDown(@enumToInt(button));
}

pub fn isMousePressed(button: MouseButton) bool {
    return raylib.IsMouseButtonPressed(@enumToInt(button));
}

pub fn isMouseReleased(button: MouseButton) bool {
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

pub fn getMouseDelta() Vec {
    var delta = raylib.GetMouseDelta();
    return math.vec2(delta.x, delta.y);
}

pub fn getMouseWheel() Vec {
    var wheel = raylib.GetMouseWheelMoveV();
    return math.vec2(wheel.x, wheel.y);
}

pub fn getMousePosition() Vec {
    var position = raylib.GetMousePosition();
    return math.vec2(position.x, position.y);
}

pub fn setMouseScale(scale: Vec) void {
    raylib.SetMouseScale(scale[0], scale[1]);
}

pub fn setMouseOffset(offset: Vec) void {
    raylib.SetMouseOffset(@floatToInt(c_int, offset[0]), @floatToInt(c_int, offset[1]));
}

pub fn setMousePosition(position: Vec) void {
    raylib.SetMousePosition(@floatToInt(c_int, position[0]), @floatToInt(c_int, position[1]));
}

pub fn setMouseCursor(cursor: MouseCursor) void {
    raylib.SetMouseCursor(@enumToInt(cursor));
}

// Bindings

// pub fn bindButtonWithMouse(button_name: []const u8) void {

// }

// pub fn bindAxisWithMouse(horizontal_axis_name: []const u8, vertical_axis_name: []const u8) void {

// }

// pub fn bindAxisWithKeyboard(axis_name: []const u8, negative_key: Key, positive_key: Key, is_smooth: bool) void {

// }

// pub fn bindButtonWithKeyboard(button_name: []const u8) void {

// }