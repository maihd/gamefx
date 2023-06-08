const std = @import("std");
const gamefx = @import("gamefx");
const combos = @import("combos.zig");

const ring = 1;
const win_stride = 5;

const col_count = 11;
const row_count = 11;

pub fn makeAnswer(board: []u8, player: u8, complexity: u32) u32 {
    var moves_buffer: [row_count * col_count]u32 = undefined;
    const moves = getMoves(board, &moves_buffer);

    var maxChild: ?u32 = null;
    var maxValue: ?u64 = null;
    for (moves) |move| {
        const curValue = minimax(board, complexity - 1, player, move);
        gamefx.trace.info("minimax value = {}", .{curValue});
        if (maxValue == null or maxValue.? < curValue) {
            gamefx.trace.info("Find new move: {}", .{move});
            maxValue = curValue;
            maxChild = move;
        }
    }

    return maxChild orelse moves[0];
}

fn minimax(board: []u8, depth: u32, player: u8, move: u32) u64 {
    if (depth == 0) {
        return heuristic(board, player, move);
    }

    std.debug.assert(board[move] == 0);
    board[move] = player;

    var alpha: u64 = 0;
    var moves_buffer: [row_count * col_count]u32 = undefined;
    const next_moves = getMoves(board, &moves_buffer);
    for (next_moves) |next_move| {
        alpha = std.math.max(alpha, minimax(board, depth - 1, if (player == 1) @as(u8, 2) else @as(u8, 1), next_move));
    }

    board[move] = 0;

    return alpha;
}

fn heuristic(board: []u8, player: u8, index: u32) u64 {
    std.debug.assert(board[index] == 0);

    const x = index % col_count;
    const y = index / col_count;

    const cur_cell = player;
    const opp_cell = if (player == 1) @as(u8, 2) else @as(u8, 1);

    var combo0: [16]u8 = undefined;
    var combo1: [16]u8 = undefined;
    var combo2: [16]u8 = undefined;
    var combo3: [16]u8 = undefined;

    board[index] = cur_cell;
    const player_value = combos.getComboValue4(
        getCombo(board, cur_cell, x, y, 1,  0, &combo0), 
        getCombo(board, cur_cell, x, y, 0,  1, &combo1), 
        getCombo(board, cur_cell, x, y, 1,  1, &combo2), 
        getCombo(board, cur_cell, x, y, 1, -1, &combo3)
    );

    board[index] = opp_cell;
    const opposite_value = combos.getComboValue4(
        getCombo(board, opp_cell, x, y, 1,  0, &combo0), 
        getCombo(board, opp_cell, x, y, 0,  1, &combo1), 
        getCombo(board, opp_cell, x, y, 1,  1, &combo2), 
        getCombo(board, opp_cell, x, y, 1, -1, &combo3)
    );

    board[index] = 0;
    return 2 * player_value + opposite_value;
}

fn unshiftArray(combo: []u8, count: u32, value: u8) u32 {
    std.debug.assert(count + 1 < combo.len);

    var i: u32 = count;
    while (i > 0) : (i -= 1) {
        combo[i] = combo[i - 1];
    }

    combo[0] = value;
    return count + 1;
}

fn getCombo(board: []const u8, player: u8, x: u32, y: u32, dx: i32, dy: i32, combo: []u8) []const u8 {
    var count: u32 = 1;
    combo[0] = 1;

    var m: i32 = 1;
    while (m < win_stride) : (m += 1) {
        const next_x1 = @intCast(i32, x) - dx * m;
        const next_y1 = @intCast(i32, y) - dy * m;
        if (next_x1 >= col_count or next_y1 >= row_count or next_x1 < 0 or next_y1 < 0) {
            break;
        }

        const next1 = board[@intCast(u32, next_x1 + next_y1 * col_count)];
        if (next1 != player and next1 != 0) {
            count = unshiftArray(combo, count, 2);
            break;
        }

        count = unshiftArray(combo, count, if (next1 == 0) 0 else 1);
        if (count == combo.len) {
            return combo[0..count];
        }
    }

    var k: i32 = 1;
    while (k < win_stride) : (k += 1) {
        const next_x = @intCast(i32, x) + dx * k;
        const next_y = @intCast(i32, y) + dy * k;
        if (next_x >= col_count or next_y >= row_count or next_x < 0 or next_y < 0) {
            break;
        }

        const next = board[@intCast(u32, next_x + next_y * col_count)];
        if (next != player and next != 0) {
            combo[count] = 2;
            count += 1;
            break;
        }

        combo[count] = if (next == 0) 0 else 1;
        count += 1;

        if (count == combo.len) {
            return combo[0..count];
        }
    }

    return combo[0..count];
}

fn arrayIncludes(array: []const u32, value: u32) bool {
    for (array) |x| {
        if (x == value) {
            return true;
        }
    }

    return false;
}

fn getMoves(board: []const u8, moves: []u32) []const u32 {
    var count: u32 = 0;

    var i: i32 = 0;
    while (i < row_count) : (i += 1) {
        var j: i32 = 0;
        while (j < col_count) : (j += 1) {
            const cur_cell = board[@intCast(u32, i * col_count + j)];
            if (cur_cell != 0 and cur_cell != 3) {
                var k = i - ring;
                while (k <= i + ring) : (k += 1) {
                    var l = j - ring;
                    while (l <= j + ring) : (l += 1) {
                        if (k >= 0 and l >= 0 and k < row_count and l < col_count) {
                            const index = @intCast(u32, k * col_count + l);
                            if (board[index] == 0 and !arrayIncludes(moves[0..count], index)) {
                                std.debug.assert(count < moves.len);
                                moves[count] = index;
                                count += 1;
                            }
                        }
                    }
                }
            }
        }
    }

    return moves[0..count];
}

pub fn getWinner(board: []const u8) u8 {
    var combo0: [16]u8 = undefined;
    var combo1: [16]u8 = undefined;
    var combo2: [16]u8 = undefined;
    var combo3: [16]u8 = undefined;

    // Find player have 5-stride combo
    for (board, 0..) |player, index| {
        const x = @intCast(u32, index) % col_count;
        const y = @intCast(u32, index) / col_count;

        const value = combos.getComboValue4(getCombo(board, player, x, y, 1, 0, &combo0), getCombo(board, player, x, y, 0, 1, &combo1), getCombo(board, player, x, y, 1, 1, &combo2), getCombo(board, player, x, y, 1, -1, &combo3));

        if (value >= combos.win_combo_value) {
            return player;
        }
    }

    // If board not full, quick return
    for (board) |cell| {
        if (cell == 0) {
            return 0;
        }
    }

    // board full
    return 3;
}
