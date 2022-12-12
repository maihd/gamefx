const std = @import("std");
const math = @import("tests/math.zig");

// Math unit tests

test {
    std.testing.refAllDecls(math);
}