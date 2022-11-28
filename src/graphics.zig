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