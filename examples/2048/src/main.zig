const gamefx = @import("gamefx");

pub fn main() !void {
    try gamefx.init(.{
        .title = "GameFX 2048",
        .width = 800,
        .height = 480
    });
    defer gamefx.deinit();

    while (!gamefx.isClosing()) {
        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();

        gamefx.graphics.clearBackground(gamefx.color32_raywhite);
        gamefx.graphics.drawText("GameFX 2048!", gamefx.math.f32x2(350, 200), 20, gamefx.color32_lightgray);
    }
}
