//const std = @import("std");
const raylib = @import("backends/raylib.zig");
const system = @import("system.zig");
const types = @import("types.zig");
const log = @import("log.zig");

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

pub fn drawTexture(texture: types.Texture, position: types.f32x2, tint: types.Color32) void {
    raylib.DrawTextureV(
        texture,                        // texture: raylib.Texture
        raylib.toVector2(position),     // position: raylib.Vector2
        raylib.toColor(tint)            // tint: raylib.Color
    );
}

/// Draw texture with extended params
/// texture - texture to draw
/// position - position to draw
/// rotation - rotation to draw, in degrees, clockwise
/// scale - scale to draw 
/// tint - tint color apply to texture
pub fn drawTextureEx(texture: types.Texture, position: types.f32x2, rotation: f32, scale: f32, tint: types.Color32) void {
    const frame_width = @intToFloat(f32, texture.width);
    const frame_height = @intToFloat(f32, texture.height);
    
    log.debug("frame_width={}, frame_height={}", .{ frame_width, frame_height });
    
    raylib.DrawTexturePro(
        texture,                        // texture: raylib.Texture
        .{
            .x = 0,
            .y = 0,
            .width = frame_width,
            .height = frame_height,
        },
        .{
            .x = position[0],
            .y = position[1],
            .width = frame_width * scale,
            .height = frame_height * scale
        },
        .{ .x = frame_width * scale * 0.5, .y = frame_height * scale * 0.5 },
        rotation,                       // rotation: c_float
        raylib.toColor(tint)            // tint: raylib.Color
    );
}

pub fn drawTextureRect(texture: types.Texture, rect: types.Rect, position: types.f32x2, tint: types.Color32) void {
    raylib.DrawTextureRec(
        texture,                            // texture: raylib.Texture
        raylib.toRectangle(rect),           // rectangle: raylib.Rectangle
        raylib.toVector2(position),         // position: raylib.Vector2
        raylib.toColor(tint)                // tint: raylib.Color
    );
}