const types = @import("types.zig");

pub fn f32x2(x: f32, y: f32) types.f32x2 {
    return types.f32x2{ x, y };
}

pub fn f32x3(x: f32, y: f32, z: f32) types.f32x3 {
    return types.f32x3{ x, y, z };
}

pub fn f32x4(x: f32, y: f32, z: f32, w: f32) types.f32x4 {
    return types.f32x4{ x, y, z, w };
}