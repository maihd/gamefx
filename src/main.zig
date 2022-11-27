const std = @import("std");
const testing = std.testing;

pub const math = @import("math.zig");
pub const types = @import("types.zig");

// Math unit tests

test "math.f32x2" {
    try testing.expectEqual(math.f32x2(1.0, 2.0), types.f32x2{ 1.0, 2.0 });
}

test "math.f32x3" {
    try testing.expectEqual(math.f32x3(1.0, 2.0, 3.0), types.f32x3{ 1.0, 2.0, 3.0 });
}

test "math.f32x4" {
    try testing.expectEqual(math.f32x4(1.0, 2.0, 3.0, 4.0), types.f32x4{ 1.0, 2.0, 3.0, 4.0 });
}