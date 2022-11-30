const raylib = @import("backends/raylib.zig");
const window = @import("window.zig");
const types = @import("types.zig");

pub fn newFrame() !void {
    if (!window.isInit()) {
        return error.WindowUnitialized;
    }

    raylib.BeginDrawing();
}

pub fn endFrame() void {
    raylib.EndDrawing();
}

pub fn clearBackground(color: types.Color32) void {
    raylib.ClearBackground(.{ 
        .r = color[0], 
        .g = color[1], 
        .b = color[2], 
        .a = color[3]
    });
}

pub fn drawText(text: []const u8, position: types.f32x2, font_size: f32, color: types.Color32) void {
    raylib.DrawText(
        @ptrCast([*c]const u8, text),       // text: const c_char*
        @floatToInt(c_int, position[0]),    // x: c_int
        @floatToInt(c_int, position[1]),    // y: c_int
        @floatToInt(c_int, font_size),      // fontSize: c_int
        .{                                  // color: raylib.Color
            .r = color[0], 
            .g = color[1], 
            .b = color[2], 
            .a = color[3]
        }
    );
}

pub fn drawCircle(position: types.f32x2, radius: f32, color: types.Color32) void {
    raylib.DrawCircle(
        @floatToInt(c_int, position[0]),    // x: c_int
        @floatToInt(c_int, position[1]),    // y: c_int
        radius,                             // radius: c_float
        .{                                  // color: raylib.Color
            .r = color[0], 
            .g = color[1], 
            .b = color[2], 
            .a = color[3]
        }
    );
}

pub fn drawTexture(texture: types.Texture, position: types.f32x2, color: types.Color32) void {
    raylib.DrawTextureV(
        texture,                            // texture: raylib.Texture
        .{                                  // position: raylib.Vector2
            .x = position[0], 
            .y = position[1] 
        },      
        .{                                  // color: raylib.Color
            .r = color[0], 
            .g = color[1], 
            .b = color[2], 
            .a = color[3]
        }
    );
}

pub fn drawTextureRect(texture: types.Texture, rect: types.Rect, position: types.f32x2, color: types.Color32) void {
    raylib.DrawTextureRec(
        texture,                            // texture: raylib.Texture
        .{                                  // rectangle: raylib.Rectangle
            .x      = rect[0],
            .y      = rect[1],
            .width  = rect[2],
            .height = rect[3]
        },
        .{                                  // position: raylib.Vector2
            .x = position[0], 
            .y = position[1] 
        },      
        .{                                  // color: raylib.Color
            .r = color[0], 
            .g = color[1], 
            .b = color[2], 
            .a = color[3]
        }
    );
}