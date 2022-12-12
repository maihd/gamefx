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

pub const DrawCircleCmd = struct {
    center: types.f32x2, 
    radius: f32, 
    color: types.Color32,

    start_angle: f32    = 0,
    end_angle: f32      = 360,
    segments: i32       = 60
};

pub const DrawTextCmd = struct {
    text: []const u8, 
    position: types.f32x2, 
    font_size: f32, 
    tint: types.Color32,
    
    font: ?types.Font       = null,
    origin: types.f32x2     = .{ 0.5, 0.5 },
    rotation: f32           = 0.0,
    spacing: f32            = 1.0
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

pub fn drawText(cmd: DrawTextCmd) void {
    const font = cmd.font orelse raylib.GetFontDefault();

    const text_sentinel = @ptrCast([*c]const u8, cmd.text);
    const text_size = raylib.MeasureTextEx(font, text_sentinel, cmd.font_size, cmd.spacing);
    raylib.DrawTextPro(
        font,                               // font: raylib.Font
        text_sentinel,                      // text: const c_char*
        raylib.toVector2(cmd.position),     // position: raylib.Vector2
        .{                                  // origin: raylib.Vector2
            .x = text_size.x * cmd.origin[0],
            .y = text_size.y * cmd.origin[1]
        },
        cmd.rotation,                       // rotation: c_float
        cmd.font_size,                      // fontSize: c_float
        cmd.spacing,                        // spacing: c_float
        raylib.toColor(cmd.tint)            // tint: raylib.Color
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

pub fn drawCircle(cmd: DrawCircleCmd) void {
    raylib.DrawCircleSector(
        raylib.toVector2(cmd.center),   // position: raylib.Vector2
        cmd.radius,                     // radius: c_float
        cmd.start_angle,                // startAngle: c_float
        cmd.end_angle,                  // endAngle: c_float
        cmd.segments,                   // segments: c_float
        raylib.toColor(cmd.color)       // color: raylib.Color
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