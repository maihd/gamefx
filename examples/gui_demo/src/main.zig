const gamefx = @import("gamefx");

pub fn main() !void {
    try gamefx.init(.{
        .title = "GameFX basic window",
        .width = 800,
        .height = 480
    });
    defer gamefx.deinit();

    while (!gamefx.isClosing()) {
        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();

        gamefx.graphics.clearBackground(gamefx.color32_raywhite);
        if (gamefx.gui.Button("Click Me", .{ 10, 10, 300, 20 })) {
            gamefx.gui.Label("Clicked!", .{ 10, 50, 300, 20 });
        }
    }
}
