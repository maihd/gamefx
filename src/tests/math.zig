const std = @import("std");
const testing = std.testing;

const math = @import("../math.zig");
const types = @import("../types.zig");

// Test deps

const zmath = @import("zmath");

test {
    testing.refAllDecls(zmath);
}

// Constructors

test "math.f32x2" {
    try testing.expectEqual(math.f32x2(1.0, 2.0), types.f32x2{ 1.0, 2.0 });
}

test "math.f32x3" {
    try testing.expectEqual(math.f32x3(1.0, 2.0, 3.0), types.f32x3{ 1.0, 2.0, 3.0 });
}

test "math.f32x4" {
    try testing.expectEqual(math.f32x4(1.0, 2.0, 3.0, 4.0), types.f32x4{ 1.0, 2.0, 3.0, 4.0 });
}

test "math.f32x2s" {
    try testing.expectEqual(math.f32x2s(1.0), types.f32x2{ 1.0, 1.0 });
}

test "math.f32x3s" {
    try testing.expectEqual(math.f32x3s(1.0), types.f32x3{ 1.0, 1.0, 1.0 });
}

test "math.f32x4s" {
    try testing.expectEqual(math.f32x4s(1.0), types.f32x4{ 1.0, 1.0, 1.0, 1.0 });
}

// Triangular

// test "math.cos" {
//     try testing.expectEqual(
//         math.cos(math.f32x2(1.0, 1.0)),
//         types.f32x2{ @cos(1.0), @cos(1.0) }
//     );
// }