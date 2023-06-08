// const std = @import("std");
const gamefx = @import("gamefx");
const logic = @import("logic.zig");

const color_background = gamefx.Color32{ 251, 248, 239, 255 };

const color_board = gamefx.Color32{ 187, 173, 160, 255 };
const color_board_cells = [_]gamefx.Color32{
    .{ 204, 192, 180, 255 },
    .{ 238, 228, 218, 255 },
    .{ 236, 224, 200, 255 },
    .{ 242, 177, 121, 255 },
    .{ 236, 141, 83, 255 },
    .{ 245, 124, 95, 255 },
    .{ 233, 89, 55, 255 },
    .{ 243, 217, 107, 255 },
};

const col_count = 11;
const row_count = 11;

const cell_size = 30;
const cell_padding = 5;

const window_margin = 30;

const window_width = col_count * cell_size + (col_count + 1) * cell_padding + window_margin * 2;
const window_height = row_count * cell_size + (row_count + 1) * cell_padding + window_margin * 2;

pub fn main() !void {
    try gamefx.init(.{ .title = "GameFX Gomoku", .width = window_width, .height = window_height });
    defer gamefx.deinit();

    var board = [_]u8{0} ** (row_count * col_count);
    var current_player: u8 = 1;

    while (!gamefx.isClosing()) {
        // if (logic.getWinner(&board) != 0) {

        // } else
        if (current_player == 2) {
            const index = logic.makeAnswer(&board, current_player, 1);
            board[index] = current_player;
            current_player = 1;
        } else {
            // user input
            user_input: {
                if (gamefx.input.isMousePressed(.left)) {
                    gamefx.trace.info("Receive use input with mouse left button pressed", .{});

                    const mouse_position = gamefx.input.getMousePosition();

                    const board_size = gamefx.graphics.getScreenSize() - gamefx.math.vec2(2 * window_margin, 2 * window_margin);
                    const board_min = gamefx.graphics.getScreenSize() * gamefx.math.vec2s(0.5) - board_size * gamefx.math.vec2s(0.5);
                    const board_max = gamefx.graphics.getScreenSize() * gamefx.math.vec2s(0.5) + board_size * gamefx.math.vec2s(0.5);

                    const cells_min = board_min + gamefx.Vec2{ cell_padding, cell_padding };
                    const cells_max = board_max - gamefx.Vec2{ cell_padding, cell_padding };

                    if (mouse_position[0] < cells_min[0] or mouse_position[1] < cells_min[1] or mouse_position[0] > cells_max[0] or mouse_position[1] > cells_max[1]) {
                        gamefx.trace.info("Mouse position is out of board scope", .{});
                        break :user_input;
                    }

                    const mouse_position_local = mouse_position - cells_min;
                    const mouse_col = @floatToInt(u32, mouse_position_local[0] / @floatCast(f32, cell_size + cell_padding));
                    const mouse_row = @floatToInt(u32, mouse_position_local[1] / @floatCast(f32, cell_size + cell_padding));
                    if (mouse_position_local[0] - @intToFloat(f32, mouse_col * (cell_size + cell_padding)) > cell_size or mouse_position_local[1] - @intToFloat(f32, mouse_row * (cell_size + cell_padding)) > cell_size) {
                        gamefx.trace.info("Mouse position is in a space of 2 cells", .{});
                        break :user_input;
                    }

                    const index = mouse_row * col_count + mouse_col;
                    if (board[index] != 0) {
                        gamefx.trace.info("Attempt to input non-empty cell at {}x{}", .{ mouse_col, mouse_row });
                        break :user_input;
                    }

                    // Set value to board
                    gamefx.trace.info("Set cell value at {}x{} = {}", .{ mouse_col, mouse_row, current_player });
                    board[index] = current_player;

                    // Move next player
                    current_player = if (current_player == 1) 2 else 1;
                    gamefx.trace.info("Next player is {}", .{current_player});
                }
            }
        }

        // drawing
        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();

        gamefx.graphics.clearBackground(color_background);
        gamefx.graphics.drawRect(.{ .position = gamefx.graphics.getScreenSize() * gamefx.math.vec2(0.5, 0.5), .size = gamefx.graphics.getScreenSize() - gamefx.math.vec2(2 * window_margin, 2 * window_margin), .color = color_board });

        for (board, 0..) |cell, i| {
            const col = i % col_count;
            const row = i / col_count;

            const x: f32 = window_margin + cell_padding + @intToFloat(f32, col * (cell_size + cell_padding));
            const y: f32 = window_margin + cell_padding + @intToFloat(f32, row * (cell_size + cell_padding));

            gamefx.graphics.drawRect(.{ .position = .{ x, y }, .size = gamefx.math.vec2s(cell_size), .color = color_board_cells[0], .origin = .{ 0.0, 0.0 } });

            switch (cell) {
                1 => {
                    gamefx.graphics.drawRect(.{ .position = .{ x + 8, y + 8 }, .size = gamefx.math.vec2s(cell_size - 16), .color = color_board_cells[1], .origin = .{ 0.0, 0.0 } });
                },

                2 => {
                    gamefx.graphics.drawCircle(.{
                        .center = .{ x + cell_size * 0.5, y + cell_size * 0.5 },
                        .radius = (cell_size - 16) * 0.5,
                        .color = color_board_cells[2],
                        .segments = 120,
                    });
                },

                else => {
                    // noops
                },
            }
        }
    }
}
