const gamefx = @import("gamefx");

pub fn main() !void {
    try gamefx.init(.{
        .title = "Input Keys",
        .width = 800,
        .height = 480
    });
    defer gamefx.deinit();

    var circle_position = gamefx.math.f32x2(400, 240);
    var circle_color = gamefx.color32_red;

    while (!gamefx.isClosing()) {
        var circle_direction = gamefx.math.f32x2(0, 0);
        if (gamefx.input.isKeyDown(.up)) {
            circle_direction[1] -= 1;
        }
        if (gamefx.input.isKeyDown(.down)) {
            circle_direction[1] += 1;
        }
        if (gamefx.input.isKeyDown(.left)) {
            circle_direction[0] -= 1;
        }
        if (gamefx.input.isKeyDown(.right)) {
            circle_direction[0] += 1;
        }

        circle_position += circle_direction;
        if (circle_direction[0] != 0 or circle_direction[1] != 0) {
            circle_color = gamefx.color32_green;
        } else {
            circle_color = gamefx.color32_red;
        }
        
        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();

        gamefx.graphics.clearBackground(gamefx.color32_raywhite);
        gamefx.graphics.drawCircle(circle_position, 30.0, circle_color);
    }
}
