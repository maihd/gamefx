const std = @import("std");
const zmath = @import("zmath");
const types = @import("types.zig");

// Exporting zmath

pub usingnamespace zmath;

// Contructors

pub inline fn vec2(x: f32, y: f32) types.Vec {
    return types.Vec{ x, y, 0.0, 1.0 }; // w = 1.0 for calculating position
}

pub inline fn vec3(x: f32, y: f32, z: f32) types.Vec {
    return types.Vec{ x, y,   z, 1.0 }; // w = 1.0 for calculating position
}

pub inline fn vec4(x: f32, y: f32, z: f32, w: f32) types.Vec {
    return types.Vec{ x, y,   z,   w };
}

pub inline fn vec2s(s: f32) types.Vec {
    return zmath.f32x4s(s);
}

pub inline fn vec3s(s: f32) types.Vec {
    return zmath.f32x4s(s);
}

pub inline fn vec4s(s: f32) types.Vec {
    return zmath.f32x4s(s);
}

// Common functions

pub inline fn isClose(a: anytype, b: @TypeOf(a)) bool {
    return zmath.isNearEqual(a, b, std.math.f32_epsilon);
}

// Graphics functions

pub inline fn degToRad(angle: f32) f32 {
    return angle * std.math.pi / 180.0;
}

pub inline fn radToDeg(angle: f32) f32 {
    return angle * 180.0 / std.math.pi;
}

pub inline fn angleRad2(v: types.Vec) f32 {
    return std.math.atan2(f32, v[1], v[0]);
}
 
pub inline fn angleDeg2(v: types.Vec) f32 {
    return radToDeg(angleRad2(v));
}

pub inline fn setLength2(v: types.Vec, length: f32) types.Vec {
    return zmath.normalize2(v) * vec2s(length);
}

pub inline fn setLength3(v: types.Vec, length: f32) types.Vec {
    return zmath.normalize3(v) * vec3s(length);
}

pub inline fn setLength4(v: types.Vec, length: f32) types.Vec {
    return zmath.normalize4(v) * vec4s(length);
}

pub inline fn fromAngleLengthRad2(angle: f32, length: f32) types.Vec {
    const rad = angle;
    return vec2(@cos(rad) * length, @sin(rad) * length);
}

pub inline fn fromAngleLengthDeg2(angle: f32, length: f32) types.Vec {
    const rad = degToRad(angle);
    return vec2(@cos(rad) * length, @sin(rad) * length);
}