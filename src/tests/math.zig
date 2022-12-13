const std = @import("std");
const testing = std.testing;

const math = @import("../math.zig");
const types = @import("../types.zig");

// Constructors

test "math.vec2" {
    try testing.expectEqual(math.vec2(1.0, 2.0), types.Vec{ 1.0, 2.0, 0.0, 1.0 });
}

test "math.vec3" {
    try testing.expectEqual(math.vec3(1.0, 2.0, 3.0), types.Vec{ 1.0, 2.0, 3.0, 1.0 });
}

test "math.vec4" {
    try testing.expectEqual(math.vec4(1.0, 2.0, 3.0, 4.0), types.Vec{ 1.0, 2.0, 3.0, 4.0 });
}

test "math.vec2s" {
    try testing.expectEqual(math.vec2s(1.0), types.Vec{ 1.0, 1.0, 1.0, 1.0 });
}

test "math.vec3s" {
    try testing.expectEqual(math.vec3s(1.0), types.Vec{ 1.0, 1.0, 1.0, 1.0 });
}

test "math.vec4s" {
    try testing.expectEqual(math.vec4s(1.0), types.Vec{ 1.0, 1.0, 1.0, 1.0 });
}