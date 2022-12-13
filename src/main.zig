// Meta

pub const version   = @import("std").SemanticVersion{ .major = 0, .minor = 1, .patch = 0 };

// Modules

pub const types     = @import("types.zig");
pub const system    = @import("system.zig");
pub const constants = @import("constants.zig");

pub const gui       = @import("gui.zig");
pub const math      = @import("math.zig");
pub const text      = @import("text.zig");
pub const input     = @import("input.zig");
pub const audio     = @import("audio.zig");
pub const assets    = @import("assets.zig");
pub const graphics  = @import("graphics.zig");

// Modules export as core

pub usingnamespace types;
pub usingnamespace system;
pub usingnamespace constants;