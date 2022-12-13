const std = @import("std");
const gamefx = @import("gamefx");

const assets_dir = @import("build_options").assets_dir;

pub fn main() !void {
    //var buffer: [1024 * 1024]u8 = undefined;
    //var fba = std.heap.FixedBufferAllocator.init(&buffer);
    //const allocator = fba.allocator();

    var config = gamefx.Config{
        .title = "GameFX Sprites",
        .width = 800,
        .height = 480
    };
    try gamefx.init(config);
    defer gamefx.deinit();

    try gamefx.assets.addSearchPath(assets_dir);
    defer gamefx.assets.removeSearchPath(assets_dir);

    const texture = try gamefx.assets.loadTexture(assets_dir ++ "/" ++ "scarfy_origin.png");
    defer gamefx.assets.unloadTexture(texture);

    const frame_width = @min(texture.width, texture.height);
    const frame_height = frame_width;

    const frame_tile_x = @intToFloat(f32, frame_width) / @intToFloat(f32, texture.width);
    const frame_tile_y = @intToFloat(f32, frame_height) / @intToFloat(f32, texture.height);

    var frame_index: i32 = 0;
    var frame_timer: f32 = 0.0;

    const frame_count: i32 = @divFloor(@max(texture.width, texture.height), frame_width);
    const frame_rate: f32 = 1.0 / @intToFloat(f32, frame_count);

    const texture_position = gamefx.graphics.getScreenSize() * gamefx.math.vec2s(0.5);

    while (!gamefx.isClosing()) {
        frame_timer += gamefx.getDeltaTime();
        if (frame_timer >= frame_rate) {
            frame_timer -= frame_rate;

            frame_index = @mod(frame_index + 1, frame_count);
        }

        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();
        
        gamefx.graphics.clearBackground(gamefx.color32_raywhite);

        const frame_rect: gamefx.Rect = if (texture.width > texture.height) .{
            @intToFloat(f32, frame_index) * frame_tile_x,
            0,
            frame_tile_x,
            frame_tile_y
        } else .{
            0,
            @intToFloat(f32, frame_index) * frame_tile_y,
            frame_tile_x,
            frame_tile_y
        };

        gamefx.graphics.drawTexture(.{
            .texture    = texture, 
            .position   = texture_position,
            .rect       = frame_rect
        });
    }
}
