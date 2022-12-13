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

    var circle_position = gamefx.graphics.getScreenSize() * gamefx.math.vec2s(0.5);
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
        var delta = mouse_position - circle_position;
        if (gamefx.math.lengthSq2(delta)[0] <= circle_radius * circle_radius) {
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
        gamefx.graphics.drawCircle(.{
            .center = circle_position, 
            .radius = circle_radius, 
            .color = circle_color
        });

        gamefx.graphics.drawText(.{
            .text       = try gamefx.text.format("Left down: {}", .{ gamefx.input.isMouseDown(.left) }), 
            .position   = gamefx.math.vec2(5, 5), 
            .font_size  = 20, 
            .origin     = gamefx.math.vec2(0, 0),
            .tint       = gamefx.color32_gray
        });

        gamefx.graphics.drawText(.{
            .text       = try gamefx.text.format("Cursor: {s}", .{ cursor_name }), 
            .position   = gamefx.math.vec2(5, 30), 
            .font_size  = 20, 
            .origin     = gamefx.math.vec2(0, 0),
            .tint       = gamefx.color32_gray
        });

        gamefx.graphics.drawText(.{
            .text       = try gamefx.text.format("Position: {d:.1} - {d:.1}", .{ mouse_position[0], mouse_position[1] }),
            .position   = gamefx.math.vec2(5, 55),
            .font_size  = 20,
            .origin     = gamefx.math.vec2(0, 0),
            .tint       = gamefx.color32_gray
        });
    }
}
