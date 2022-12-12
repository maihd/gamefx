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
        gamefx.graphics.drawText(.{
            .text = "Congrats! You created your first window!", 
            .position = .{ 400, 240 }, 
            .font_size = 20, 
            .tint = gamefx.color32_lightgray
        });
    }
}
