const gamefx = @import("gamefx");

pub fn main() !void {
    try gamefx.init(.{
        .title = "GameFX neon shooter",
        .width = 800,
        .height = 480
    });
    defer gamefx.deinit();

    while (!gamefx.isClosing()) {
        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();

        gamefx.graphics.clearBackground(gamefx.color32_raywhite);
        gamefx.graphics.drawText("Neon Shooter Game!", .{ 310, 220 }, 20, gamefx.color32_lightgray);
    }
}
