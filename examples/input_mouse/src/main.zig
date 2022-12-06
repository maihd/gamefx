const std = @import("std");
const gamefx = @import("gamefx");

pub fn main() !void {
    var config = gamefx.Config{
        .title = "GameFX Input Mouse",
        .width = 800,
        .height = 480
    };
    try gamefx.init(config);
    defer gamefx.deinit();

    var circle_position = gamefx.math.f32x2(
        @intToFloat(f32, @divExact(config.width, 2)), 
        @intToFloat(f32, @divExact(config.height, 2))
    );

    var circle_color    = gamefx.color32_red;
    var circle_radius   = @as(f32, 20.0);

    var circle_holding  = false;

    while (!gamefx.isClosing()) {
        var mouse_position = gamefx.input.getMousePosition();

        if (circle_holding) {
            circle_position = mouse_position;
            circle_color = gamefx.color32_green;
        } else {
            circle_color = gamefx.color32_red;
        }

        var cursor_name: []const u8 = "Arrow";
        var delta_x = mouse_position[0] - circle_position[0];
        var delta_y = mouse_position[1] - circle_position[1];
        if (delta_x * delta_x + delta_y * delta_y <= circle_radius * circle_radius) {
            gamefx.input.setMouseCursor(.pointing_hand);
            circle_holding = gamefx.input.isMouseDown(.left);
            cursor_name = "Pointing Hand";
        } else {
            gamefx.input.setMouseCursor(.default);
            circle_holding = false;
        }

        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();
        
        gamefx.graphics.clearBackground(gamefx.color32_raywhite);
        gamefx.graphics.drawCircle(circle_position, circle_radius, circle_color);

        var mouse_button_text = try gamefx.text.format("Left down: {}", .{ gamefx.input.isMouseDown(.left) });
        gamefx.graphics.drawText(mouse_button_text, .{ 5, 5 }, 20, gamefx.color32_gray);

        var mouse_cursor_text = try gamefx.text.format("Cursor: {s}", .{ cursor_name });
        gamefx.graphics.drawText(mouse_cursor_text, .{ 5, 30 }, 20, gamefx.color32_gray);

        var mouse_position_text = try gamefx.text.format("Position: {d:.1} - {d:.1}", .{ mouse_position[0], mouse_position[1] });
        gamefx.graphics.drawText(mouse_position_text, .{ 5, 55 }, 20, gamefx.color32_gray);
    }
}
