const std = @import("std");
const testing = std.testing;

const math = @import("../math.zig");
const types = @import("../types.zig");

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

test "math.sin" {
    try testing.expectEqual(
        math.sin(math.f32x2(1.0, 1.0)),
        types.f32x2{ @sin(1.0), @sin(1.0) }
    );
    
    try testing.expectEqual(
        math.sin(math.f32x3(1.0, 1.0, 1.0)),
        types.f32x3{ @sin(1.0), @sin(1.0), @sin(1.0) }
    );
    
    try testing.expectEqual(
        math.sin(math.f32x4(1.0, 1.0, 1.0, 1.0)),
        types.f32x4{ @sin(1.0), @sin(1.0), @sin(1.0), @sin(1.0) }
    );
}

test "math.cos" {
    try testing.expectEqual(
        math.cos(math.f32x2(1.0, 1.0)),
        types.f32x2{ @cos(1.0), @cos(1.0) }
    );
    
    try testing.expectEqual(
        math.cos(math.f32x3(1.0, 1.0, 1.0)),
        types.f32x3{ @cos(1.0), @cos(1.0), @cos(1.0) }
    );
    
    try testing.expectEqual(
        math.cos(math.f32x4(1.0, 1.0, 1.0, 1.0)),
        types.f32x4{ @cos(1.0), @cos(1.0), @cos(1.0), @cos(1.0) }
    );
}

test "math.tan" {
    try testing.expectEqual(
        math.tan(math.f32x2(1.0, 1.0)),
        types.f32x2{ @tan(1.0), @tan(1.0) }
    );
    
    try testing.expectEqual(
        math.tan(math.f32x3(1.0, 1.0, 1.0)),
        types.f32x3{ @tan(1.0), @tan(1.0), @tan(1.0) }
    );
    
    try testing.expectEqual(
        math.tan(math.f32x4(1.0, 1.0, 1.0, 1.0)),
        types.f32x4{ @tan(1.0), @tan(1.0), @tan(1.0), @tan(1.0) }
    );
}

test "math.mul(f32, f32x4x4)" {
    const m = types.f32x4x4{
        math.f32x4(0.1, 0.2, 0.3, 0.4),
        math.f32x4(0.5, 0.6, 0.7, 0.8),
        math.f32x4(0.9, 1.0, 1.1, 1.2),
        math.f32x4(1.3, 1.4, 1.5, 1.6),
    };
    const ms = math.mul(@as(f32, 2.0), m);
    try testing.expect(math.isClose(ms[0], math.f32x4(0.2, 0.4, 0.6, 0.8)));
    try testing.expect(math.isClose(ms[1], math.f32x4(1.0, 1.2, 1.4, 1.6)));
    try testing.expect(math.isClose(ms[2], math.f32x4(1.8, 2.0, 2.2, 2.4)));
    try testing.expect(math.isClose(ms[3], math.f32x4(2.6, 2.8, 3.0, 3.2)));
}

test "math.mul(f32x4x4, f32)" {
    const m = types.f32x4x4{
        math.f32x4(0.1, 0.2, 0.3, 0.4),
        math.f32x4(0.5, 0.6, 0.7, 0.8),
        math.f32x4(0.9, 1.0, 1.1, 1.2),
        math.f32x4(1.3, 1.4, 1.5, 1.6),
    };
    const ms = math.mul(m, @as(f32, 2.0));
    try testing.expect(math.isClose(ms[0], math.f32x4(0.2, 0.4, 0.6, 0.8)));
    try testing.expect(math.isClose(ms[1], math.f32x4(1.0, 1.2, 1.4, 1.6)));
    try testing.expect(math.isClose(ms[2], math.f32x4(1.8, 2.0, 2.2, 2.4)));
    try testing.expect(math.isClose(ms[3], math.f32x4(2.6, 2.8, 3.0, 3.2)));
}