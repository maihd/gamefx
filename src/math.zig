const types = @import("types.zig");
const zmath = @import("zmath");

// Contructors

pub fn f32x2(x: f32, y: f32) types.f32x2 {
    return types.f32x2{ x, y };
}

pub fn f32x3(x: f32, y: f32, z: f32) types.f32x3 {
    return types.f32x3{ x, y, z };
}

pub fn f32x4(x: f32, y: f32, z: f32, w: f32) types.f32x4 {
    return types.f32x4{ x, y, z, w };
}

pub fn f32x2s(s: f32) types.f32x2 {
    return types.f32x2{ s, s };
}

pub fn f32x3s(s: f32) types.f32x3 {
    return types.f32x3{ s, s, s };
}

pub fn f32x4s(s: f32) types.f32x4 {
    return types.f32x4{ s, s, s, s };
}

// Per types functions

// Generic functions

pub fn sin(v: anytype) @TypeOf(v) {
    const T = @TypeOf(v);
    return switch (T) {
        f32, types.f32x4, types.f32x4x4 => zmath.sin(v),
        types.f32x2, types.f32x3 => zmath.sin32xN(v),
        else => @compileError("gamefx.math.sin() not implemented for " ++ @typeName(T)),
    };
}

pub fn cos(v: anytype) @TypeOf(v) {
    const T = @TypeOf(v);
    return switch (T) {
        f32, types.f32x4, types.f32x4x4 => zmath.cos(v),
        types.f32x2, types.f32x3 => zmath.cos32xN(v),
        else => @compileError("gamefx.math.sin() not implemented for " ++ @typeName(T)),
    };
}

pub fn tan(v: anytype) @TypeOf(v) {
    const T = @TypeOf(v);
    return switch (T) {
        f32, types.f32x4, types.f32x4x4 => zmath.tan(v),
        types.f32x2, types.f32x3 => zmath.tan32xN(v),
        else => @compileError("gamefx.math.sin() not implemented for " ++ @typeName(T)),
    };
}