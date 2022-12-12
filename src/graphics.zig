//const std = @import("std");
const raylib = @import("backends/raylib.zig");
const system = @import("system.zig");
const types = @import("types.zig");
const log = @import("log.zig");
const constants = @import("constants.zig");

// Draw commands

pub const DrawRectCmd = struct {
    position: types.f32x2,
    size: types.f32x2,
    color: types.Color32,
    
    scale: types.f32x2      = .{ 1.0, 1.0 },
    origin: types.f32x2     = .{ 0.5, 0.5 },
    rotation: f32           = 0.0,
};

pub const DrawTextureCmd = struct {
    texture: types.Texture,
    position: types.f32x2,

    rect: types.f32x4       = .{ 0.0, 0.0, 1.0, 1.0 },
    scale: types.f32x2      = .{ 1.0, 1.0 },
    origin: types.f32x2     = .{ 0.5, 0.5 },
    rotation: f32           = 0.0,
    tint: types.Color32     = constants.color32_white,
};

// Drawing state

pub fn newFrame() !void {
    if (!system.isInit()) {
        return error.SystemUninitialized;
    }

    raylib.BeginDrawing();
}

pub fn endFrame() void {
    raylib.EndDrawing();
}

pub fn clearBackground(color: types.Color32) void {
    raylib.ClearBackground(raylib.toColor(color));
}

pub fn drawBackground(texture: types.Texture, tint: types.Color32) void {
    const screen_size = getScreenSize();
    
    raylib.DrawTexturePro(
        texture,                                // texture: raylib.Texture
        .{                                      // source: raylib.Rectangle
            .x = 0,
            .y = 0,
            .width = @intToFloat(f32, texture.width),
            .height = @intToFloat(f32, texture.height),
        },
        .{                                      // dest: raylib.Rectangle
            .x = 0.0,
            .y = 0.0,
            .width = screen_size[0],
            .height = screen_size[1]
        },
        .{                                      // origin: raylib.Vector2
            .x = 0.0, 
            .y = 0.0 
        },
        0.0,                                    // rotation: c_float
        raylib.toColor(tint)                    // tint: raylib.Color
    );
}

// Graphics state

pub fn getScreenSize() types.f32x2 {
    return .{
        @intToFloat(f32, raylib.GetScreenWidth()),
        @intToFloat(f32, raylib.GetScreenHeight()),
    };
}

pub fn getRenderSize() types.f32x2 {
    return .{
        @intToFloat(f32, raylib.GetRenderWidth()),
        @intToFloat(f32, raylib.GetRenderHeight()),
    };
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

pub fn drawRect(cmd: DrawRectCmd) void {
    const draw_size     = cmd.size * cmd.scale;
    const draw_origin   = draw_size * cmd.origin;

    raylib.DrawRectanglePro(
        .{
            .x      = cmd.position[0],
            .y      = cmd.position[1],
            .width  = draw_size[0],
            .height = draw_size[1],
        },
        raylib.toVector2(draw_origin),  // origin: raylib.Vector2
        cmd.rotation,                   // rotation: c_float
        raylib.toColor(cmd.color)       // color: raylib.Color
    );
}

pub fn drawCircle(position: types.f32x2, radius: f32, color: types.Color32) void {
    raylib.DrawCircleV(
        raylib.toVector2(position),     // position: raylib.Vector2
        radius,                         // radius: c_float
        raylib.toColor(color)           // color: raylib.Color
    );
}

// Draw shapes

/// Draw texture
/// cmd - draw command
pub fn drawTexture(cmd: DrawTextureCmd) void {
    const texture_width = @intToFloat(f32, cmd.texture.width);
    const texture_height = @intToFloat(f32, cmd.texture.height);

    const tile_width = cmd.rect[2] * texture_width;
    const tile_height = cmd.rect[3] * texture_height;

    const draw_width = tile_width * cmd.scale[0];
    const draw_height = tile_height * cmd.scale[1];
    
    raylib.DrawTexturePro(
        cmd.texture,                            // texture: raylib.Texture
        .{                                      // source: raylib.Rectangle
            .x      = cmd.rect[0] * texture_width,
            .y      = cmd.rect[1] * texture_height,
            .width  = tile_width,
            .height = tile_height,
        },
        .{                                      // dest: raylib.Rectangle
            .x      = cmd.position[0],
            .y      = cmd.position[1],
            .width  = draw_width,
            .height = draw_height
        },
        .{                                      // origin: raylib.Vector2
            .x = draw_width * cmd.origin[0], 
            .y = draw_height * cmd.origin[1]
        },
        cmd.rotation,                           // rotation: c_float
        raylib.toColor(cmd.tint)                // tint: raylib.Color
    );
}