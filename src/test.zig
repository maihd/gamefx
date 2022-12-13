const std = @import("std");

// Test deps

test {
    std.testing.refAllDecls(@import("zmath"));
}

// Math unit tests

test {
    std.testing.refAllDecls(@import("tests/math.zig"));
}