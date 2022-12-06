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

// Per types functions

// Generic functions