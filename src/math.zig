const std = @import("std");
const zmath = @import("zmath");
const types = @import("types.zig");

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

// Common functions

pub const approxEqAbs = zmath.approxEqAbs;

pub fn isClose(a: anytype, b: @TypeOf(a)) bool {
    return approxEqAbs(a, b, std.math.f32_epsilon);
}

// Graphics functions

pub fn sin(v: anytype) @TypeOf(v) {
    const T = @TypeOf(v);
    return switch (T) {
        f32, types.f32x4, types.f32x4x4 => zmath.sin(v),
        types.f32x2 => .{ @sin(v[0]), @sin(v[1]) },
        types.f32x3 => .{ @sin(v[0]), @sin(v[1]), @sin(v[2]) },
        else => @compileError("gamefx.math.sin() not implemented for " ++ @typeName(T)),
    };
}

pub fn cos(v: anytype) @TypeOf(v) {
    const T = @TypeOf(v);
    return switch (T) {
        f32, types.f32x4, types.f32x4x4 => zmath.cos(v),
        types.f32x2 => .{ @cos(v[0]), @cos(v[1]) },
        types.f32x3 => .{ @cos(v[0]), @cos(v[1]), @cos(v[2]) },
        else => @compileError("gamefx.math.sin() not implemented for " ++ @typeName(T)),
    };
}

pub fn tan(v: anytype) @TypeOf(v) {
    const T = @TypeOf(v);
    return switch (T) {
        f32, types.f32x4, types.f32x4x4 => @tan(v),
        types.f32x2 => .{ @tan(v[0]), @tan(v[1]) },
        types.f32x3 => .{ @tan(v[0]), @tan(v[1]), @tan(v[2]) },
        else => @compileError("gamefx.math.sin() not implemented for " ++ @typeName(T)),
    };
}

fn mulRetType(comptime Ta: type, comptime Tb: type) type {
    if (Ta == types.f32x4x4 and Tb == types.f32x4x4) {
        return types.f32x4x4;
    } else if ((Ta == f32 and Tb == types.f32x4x4) or (Ta == types.f32x4x4 and Tb == f32)) {
        return types.f32x4x4;
    } else if ((Ta == types.f32x4 and Tb == types.f32x4x4) or (Ta == types.f32x4x4 and Tb == types.f32x4)) {
        return types.f32x4;
    } else if ((Ta == types.f32x3 and Tb == types.f32x4x4) or (Ta == types.f32x4x4 and Tb == types.f32x3)) {
        return types.f32x3;
    } else if ((Ta == types.f32x2 and Tb == types.f32x4x4) or (Ta == types.f32x4x4 and Tb == types.f32x2)) {
        return types.f32x2;
    }

    @compileError("gamefx.math.mul() not implemented for types: " ++ @typeName(Ta) ++ @typeName(Tb));
}

pub fn mul(a: anytype, b: anytype) mulRetType(@TypeOf(a), @TypeOf(b)) {
    const Ta = @TypeOf(a);
    const Tb = @TypeOf(b);
    if (Ta == types.f32x4x4 and Tb == types.f32x4x4) {
        return zmath.mul(a, b);
    } else if ((Ta == f32 and Tb == types.f32x4x4) or (Ta == types.f32x4x4 and Tb == f32)) {
        return zmath.mul(a, b);
    } else if ((Ta == types.f32x4 and Tb == types.f32x4x4) or (Ta == types.f32x4x4 and Tb == types.f32x4)) {
        return zmath.mul(a, b);
    } else if (Ta == types.f32x3 and Tb == types.f32x4x4) {
        const v4 = zmath.mul(types.f32x4{ a[0], a[1], a[2], 1.0 }, b);
        return types.f32x3{ v4[0], v4[1], v4[2] };
    } else if (Ta == types.f32x4x4 and Tb == types.f32x3) {
        const v4 = zmath.mul(a, types.f32x4{ b[0], b[1], b[2], 1.0 });
        return types.f32x3{ v4[0], v4[1], v4[2] };
    } else if (Ta == types.f32x2 and Tb == types.f32x4x4) {
        const v4 = zmath.mul(types.f32x4{ a[0], a[1], 0.0, 1.0 }, b);
        return types.f32x3{ v4[0], v4[1] };
    } else if (Ta == types.f32x4x4 and Tb == types.f32x2) {
        const v4 = zmath.mul(a, types.f32x4{ b[0], b[1], 0.0, 1.0 });
        return types.f32x3{ v4[0], v4[1] };
    }

    @compileError("gamefx.math.mul() not implemented for types: " ++ @typeName(Ta) ++ ", " ++ @typeName(Tb));
}