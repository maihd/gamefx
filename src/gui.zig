const raylib = @import("backends/raylib.zig");
const types = @import("types.zig");

pub fn Label(text: []const u8, bounds: types.Rect) void {
    raylib.GuiLabel(
        .{                              // bounds: raylib.Rectangle
            .x      = bounds[0],
            .y      = bounds[1],
            .width  = bounds[2],
            .height = bounds[3]
        }, 
        @ptrCast([*c]const u8, text)    // text: const c_char*
    );
}

pub fn Button(text: []const u8, bounds: types.Rect) bool {
    return raylib.GuiButton(
        .{                              // bounds: raylib.Rectangle
            .x      = bounds[0],
            .y      = bounds[1],
            .width  = bounds[2],
            .height = bounds[3]
        }, 
        @ptrCast([*c]const u8, text)    // text: const c_char*
    );
}