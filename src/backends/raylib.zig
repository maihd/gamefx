pub usingnamespace raylib;

const types = @import("../types.zig");
const raylib = @cImport({
    @cInclude("raylib.h");
    
    @cDefine("RAYGUI_IMPLEMENTATION", "");
    @cInclude("raygui.h");
});

pub inline fn toVector2(v: anytype) raylib.Vector2 {
    const Type = @TypeOf(v);
    return switch (Type) {
        types.f32x2 => .{ .x = v[0], .y = v[1] },
        else => @compileError("Cannot convert to raylib.Vector2")  
    };
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

pub inline fn toRectangle(v: anytype) raylib.Rectangle {
    const Type = @TypeOf(v);
    return switch (Type) {
        types.Rect => .{
            .x      = v[0], 
            .y      = v[1], 
            .width  = v[2], 
            .height = v[3]
        },

        else => @compileError("Cannot convert to raylib.Color")  
    };
}