const raylib = @import("backends/raylib.zig");
const system = @import("system.zig");
const types = @import("types.zig");

// Drawing state

pub fn newFrame() !void {
    if (!system.isInit()) {
        return error.SystemUnitialized;
    }

    raylib.BeginDrawing();
}

pub fn endFrame() void {
    raylib.EndDrawing();
}

pub fn clearBackground(color: types.Color32) void {
    raylib.ClearBackground(raylib.toColor(color));
}

// Draw text

pub fn drawText(text: []const u8, position: types.f32x2, font_size: f32, color: types.Color32) void {
    raylib.DrawText(
        @ptrCast([*c]const u8, text),       // text: const c_char*
        @floatToInt(c_int, position[0]),    // posX: c_int
        @floatToInt(c_int, position[1]),    // posY: c_int
        @floatToInt(c_int, font_size),      // fontSize: c_int
        raylib.toColor(color)               // color: raylib.Color
    );
}

// Draw shapes

pub fn drawCircle(position: types.f32x2, radius: f32, color: types.Color32) void {
    raylib.DrawCircleV(
        raylib.toVector2(position),     // position: raylib.Vector2
        radius,                         // radius: c_float
        raylib.toColor(color)           // color: raylib.Color
    );
}

// Draw shapes

pub fn drawTexture(texture: types.Texture, position: types.f32x2, color: types.Color32) void {
    raylib.DrawTextureV(
        texture,                        // texture: raylib.Texture
        raylib.toVector2(position),     // position: raylib.Vector2
        raylib.toColor(color)           // color: raylib.Color
    );
}

pub fn drawTextureRect(texture: types.Texture, rect: types.Rect, position: types.f32x2, color: types.Color32) void {
    raylib.DrawTextureRec(
        texture,                            // texture: raylib.Texture
        raylib.toRectangle(rect),           // rectangle: raylib.Rectangle
        raylib.toVector2(position),         // position: raylib.Vector2
        raylib.toColor(color)               // color: raylib.Color
    );
}