// Types

const NPatchInfo = @This();
pub const Layout = enum(u32) {
    both = 0,           // Npatch layout: 3x3 tiles
    vertical,           // Npatch layout: 1x3 tiles
    horizontal,         // Npatch layout: 3x1 tiles
};

// Fields

source: [4]f32,         // Texture source rectangle
left: f32,              // Left border offset
top: f32,               // Top border offset
right: f32,             // Right border offset
bottom: f32,            // Bottom border offset
layout: Layout,         // Layout of the n-patch: 3x3, 1x3 or 3x1

// Methods

