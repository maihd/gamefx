const std = @import("std");
const gamefx = @import("gamefx");

const assets_dir = @import("build_options").assets_dir;

// Shorthand to cast *anyopaque to T*
pub fn refCast(comptime T: type, ptr: *anyopaque) *T {
    return @ptrCast(*T, @alignCast(@alignOf(*T), ptr));
}

// Node
const Node = struct {
    ptr: *anyopaque,
    draw_fn: *const fn (ptr: *anyopaque) void,

    pub fn draw(self: *const Node) void {
        self.draw_fn(self.ptr);
    }
};

// Scene
const Scene = struct {
    root_node: ?Node,

    pub fn draw(self: *Scene) void {
        if (self.root_node) |node| {
            node.draw();
        }    
    }
};

// Group of nodes
const Group = struct {
    nodes: std.ArrayList(Node),

    pub fn draw(ptr: *anyopaque) void {
        var self = refCast(Group, ptr);
        for (self.nodes.items) |child| {
            child.draw();
        }
    }

    pub fn node(self: *Group) Node {
        return .{
            .ptr = self,
            .draw_fn = &Group.draw
        };
    }
};

// Simple node display the texture
const Spriter = struct {
    texture: *gamefx.Texture,
    position: gamefx.Vec2,

    pub fn draw(ptr: *anyopaque) void {
        var self = refCast(Spriter, ptr);
        gamefx.graphics.drawTexture(.{
            .texture = self.texture,
            .position = self.position
        });
    }

    pub fn node(self: *Spriter) Node {
        return .{
            .ptr = self,
            .draw_fn = &Spriter.draw
        };
    }
};

pub fn main() !void {
    try gamefx.init(.{ .title = "GameFX SceneGraph", .width = 800, .height = 600 });
    defer gamefx.deinit();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var group = Group{ .nodes = std.ArrayList(Node).init(allocator) };

    const texture = try gamefx.assets.loadTexture(assets_dir ++ "/" ++ "scarfy_origin.png");
    defer gamefx.assets.unloadTexture(texture);
    
    var spriter = Spriter { 
        .texture = texture,
        .position = .{ 400, 300 }
    };
    try group.nodes.append(spriter.node());

    var scene = Scene{ .root_node = group.node() };

    while (!gamefx.isClosing()) {
        // drawing
        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();

        gamefx.graphics.clearBackground(gamefx.color32_raywhite);
        scene.draw();
    }
}
