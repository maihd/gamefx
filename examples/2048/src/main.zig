const gamefx = @import("gamefx");

const color_background  = gamefx.Color32{ 251, 248, 239, 255 };

const color_board       = gamefx.Color32{ 187, 173, 160, 255 };
const color_board_cells = [_]gamefx.Color32{ 
    .{ 204, 192, 180, 255 },
    .{ 238, 228, 218, 255 },
    .{ 236, 224, 200, 255 },
    .{ 242, 177, 121, 255 },
    .{ 236, 141,  83, 255 },
    .{ 245, 124,  95, 255 },
    .{ 233,  89,  55, 255 },
    .{ 243, 217, 107, 255 },
};

const font_size_cells   = [_]f32{ 0, 1, 2 };

const col_count         = 4;
const row_count         = 4;
const board             = [col_count][row_count]i32{
    .{ 0, 0, 0, 0 },
    .{ 0, 0, 0, 0 },
    .{ 0, 0, 0, 0 },
    .{ 0, 0, 0, 0 },
};

const cell_size         = 80;
const cell_padding      = 16;

const window_margin     = 30;

const window_width      = col_count * cell_size + (col_count + 1) * cell_padding + window_margin * 2;
const window_height     = row_count * cell_size + (row_count + 1) * cell_padding + window_margin * 2;

pub fn main() !void {
    try gamefx.init(.{
        .title = "GameFX 2048",
        .width = window_width,
        .height = window_height
    });
    defer gamefx.deinit();

    while (!gamefx.isClosing()) {
        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();

        gamefx.graphics.clearBackground(color_background);
        gamefx.graphics.drawRect(.{
            .position   = gamefx.graphics.getScreenSize() * gamefx.math.f32x2(0.5, 0.5),
            .size       = gamefx.graphics.getScreenSize() - gamefx.math.f32x2(2 * window_margin, 2 * window_margin),
            .color      = color_board
        });

        var y: f32 = window_margin + cell_padding;
        for (board) |row| {
            var x: f32 = window_margin + cell_padding;
            
            for (row) |cell| {
                _ = cell;

                gamefx.graphics.drawRect(.{
                    .position   = .{ x, y },
                    .size       = gamefx.math.f32x2s(@as(f32, cell_size)),
                    .color      = color_board_cells[0],
                    .origin     = .{ 0.0, 0.0 }
                });

                x += cell_size + cell_padding;
            }
            
            y += cell_size + cell_padding;
        }
    }
}

//

const std = @import("std");
const testing = std.testing;

const BoardState = struct {
    data: [rows][cols]u32,

    const Self = @This();
    
    const cols = 4;
    const rows = 4;

    pub fn moveLeft(self: *Self) bool {
        var result = false;

        for (self.data) |*row| {
            var i: i32 = 1;
            i_loop: while (i < cols) : (i += 1) {
                var j: i32 = i - 1;
                while (j >= 0) : (j -= 1) {
                    const idx_i = @intCast(usize, i);
                    const idx_j = @intCast(usize, j);

                    if (row[idx_i] == row[idx_j]) {
                        row[idx_j] *= 2;
                        row[idx_i]  = 0;
                        result = true;
                        continue :i_loop;
                    } else if (row[idx_j] != 0) {
                        break;
                    }
                }

                const idx_i = @intCast(usize, i);
                const idx_j = @intCast(usize, j + 1);
                if (row[idx_j] == 0) {
                    row[idx_j] = row[idx_i];
                    row[idx_i] = 0;

                    result = true;
                }
            }
        }

        return result;
    }

    pub fn moveRight(self: *Self) bool {
        var result = false;

        for (self.data) |*row| {
            var i: i32 = cols - 2;
            i_loop: while (i >= 0) : (i -= 1) {
                var j: i32 = i + 1;
                while (j < cols) : (j += 1) {
                    const idx_i = @intCast(usize, i);
                    const idx_j = @intCast(usize, j);

                    if (row[idx_i] == row[idx_j]) {
                        row[idx_j] *= 2;
                        row[idx_i]  = 0;
                        result = true;
                        continue :i_loop;
                    } else if (row[idx_j] != 0) {
                        break;
                    }
                }

                const idx_i = @intCast(usize, i);
                const idx_j = @intCast(usize, j - 1);
                if (row[idx_j] == 0) {
                    row[idx_j] = row[idx_i];
                    row[idx_i] = 0;

                    result = true;
                }
            }
        }

        return result;
    }

    pub fn moveUp() bool {
        return false;
    } 

    pub fn moveDown() bool {
        return false;
    }

    pub fn isEnd() bool {
        return !moveLeft() and !moveRight() and !moveUp() and !moveDown();
    }
};
test "Board.moveLeft()" {
    var test_board = BoardState{
        .data = .{
            .{ 1, 1, 0, 0 },
            .{ 0, 0, 1, 1 },
            .{ 0, 1, 0, 1 },
            .{ 1, 1, 1, 0 }
        }
    };
    const test_board_moved = BoardState{
        .data = .{
            .{ 2, 0, 0, 0 },
            .{ 2, 0, 0, 0 },
            .{ 2, 0, 0, 0 },
            .{ 2, 1, 0, 0 }
        }
    };
    try testing.expect(test_board.moveLeft());
    try testing.expectEqual(test_board.data, test_board_moved.data);
}

test "Board.moveRight()" {
    var test_board = BoardState{
        .data = .{
            .{ 1, 1, 0, 0 },
            .{ 0, 0, 1, 1 },
            .{ 0, 1, 0, 1 },
            .{ 1, 1, 1, 0 }
        }
    };
    const test_board_moved = BoardState{
        .data = .{
            .{ 0, 0, 0, 2 },
            .{ 0, 0, 0, 2 },
            .{ 0, 0, 0, 2 },
            .{ 0, 0, 1, 2 }
        }
    };
    try testing.expect(test_board.moveRight());
    try testing.expectEqual(test_board.data, test_board_moved.data);
}

test "Board.moveUp()" {

}

test "Board.moveDown()" {
    
}

test "Board.isEnd()" {
    
}