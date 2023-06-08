const std = @import("std");
const zmath = @import("zmath");
const types = @import("types.zig");

// Exporting zmath

pub usingnamespace zmath;

// Contructors

pub inline fn vec2(x: f32, y: f32) types.Vec2 {
    return .{ x, y };
}

pub inline fn vec3(x: f32, y: f32, z: f32) types.Vec3 {
    return .{ x, y, z, 1.0 }; // w = 1.0 for calculating position
}

pub inline fn vec4(x: f32, y: f32, z: f32, w: f32) types.Vec4 {
    return .{ x, y, z,   w };
}

pub inline fn vec2s(s: f32) types.Vec2 {
    return .{ s, s };
}

pub inline fn vec3s(s: f32) types.Vec3 {
    return zmath.f32x4s(s);
}

pub inline fn vec4s(s: f32) types.Vec4 {
    return zmath.f32x4s(s);
}

// Extended functions

pub inline fn isClose(a: anytype, b: @TypeOf(a)) bool {
    return zmath.approxEqAbs(a, b, std.math.f32_epsilon);
}

pub inline fn isNearZero(v: anytype) bool {
    return isClose(v, zmath.splat(@TypeOf(v), 0.0));
}

pub inline fn isLengthZero2(v: anytype) bool {
    return isClose(zmath.lengthSq2(v), zmath.splat(@TypeOf(v), 0.0));
}

pub inline fn isLengthZero3(v: anytype) bool {
    return isClose(zmath.lengthSq3(v), zmath.splat(@TypeOf(v), 0.0));
}

pub inline fn isLengthZero4(v: anytype) bool {
    return isClose(zmath.lengthSq4(v), zmath.splat(@TypeOf(v), 0.0));
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

// 2D Graphics functions

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

pub inline fn vec2FromRadians(radians: f32, length: f32) types.Vec {
    const rad = radians;
    return vec2(zmath.cos(rad) * length, zmath.sin(rad) * length);
}

pub inline fn vec2FromDegrees(degrees: f32, length: f32) types.Vec {
    const rad = degToRad(degrees);
    return vec2(zmath.cos(rad) * length, zmath.sin(rad) * length);
}