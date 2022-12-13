pub usingnamespace raylib;

const types = @import("../types.zig");
const raylib = @cImport({
    @cInclude("raylib.h");
    
    @cDefine("RAYGUI_IMPLEMENTATION", "");
    @cInclude("raygui.h");
});

// Convert functions

pub inline fn toVector2(vec: types.Vec) raylib.Vector2 {
    return .{ .x = vec[0], .y = vec[1] };
}

pub inline fn toColor(v: anytype) raylib.Color {
    const Type = @TypeOf(v);
    return switch (Type) {
        types.Color => .{
            .r = @floatToInt(u8, v[0] * 255.0), 
            .g = @floatToInt(u8, v[1] * 255.0), 
            .b = @floatToInt(u8, v[2] * 255.0), 
            .a = @floatToInt(u8, v[3] * 255.0)
        },

        types.Color32 => .{
            .r = v[0], 
            .g = v[1], 
            .b = v[2], 
            .a = v[3]
        },

        else => @compileError("Cannot convert to raylib.Color")  
    };
}

pub inline fn toRectangle(rect: types.Rect) raylib.Rectangle {
    return .{
        .x      = rect[0], 
        .y      = rect[1], 
        .width  = rect[2], 
        .height = rect[3]
    };
}