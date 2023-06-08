pub const win_combo_value = 10_000_000_000;

pub const combos_win = [_][]const u8{&[_]u8{ 1, 1, 1, 1, 1 }};
pub const combos_uncovered4 = [_][]const u8{
    &[_]u8{ 0, 1, 1, 1, 1, 0 },
    &[_]u8{ 0, 1, 1, 1, 0, 1 },
    &[_]u8{ 1, 0, 1, 1, 1, 0 },
    &[_]u8{ 1, 1, 1, 0, 1, 0 },
    &[_]u8{ 1, 1, 1, 0, 1, 1 },
    &[_]u8{ 1, 1, 0, 1, 1, 1 },
    &[_]u8{ 1, 0, 1, 1, 1, 1 },
};
pub const combos_uncovered3 = [_][]const u8{ &[_]u8{ 0, 1, 1, 1, 0, 0 }, &[_]u8{ 0, 0, 1, 1, 1, 0 }, &[_]u8{ 0, 1, 0, 1, 1, 0 }, &[_]u8{ 0, 1, 1, 0, 1, 0 } };
pub const combos_uncovered2 = [_][]const u8{ &[_]u8{ 0, 0, 1, 1, 0, 0 }, &[_]u8{ 0, 1, 0, 1, 0, 0 }, &[_]u8{ 0, 0, 1, 0, 1, 0 }, &[_]u8{ 0, 1, 1, 0, 0, 0 }, &[_]u8{ 0, 0, 0, 1, 1, 0 }, &[_]u8{ 0, 1, 0, 0, 1, 0 } };
pub const combos_covered4 = [_][]const u8{ &[_]u8{ 2, 1, 0, 1, 1, 1 }, &[_]u8{ 2, 1, 1, 0, 1, 1 }, &[_]u8{ 2, 1, 1, 1, 0, 1 }, &[_]u8{ 2, 1, 1, 1, 1, 0 }, &[_]u8{ 0, 1, 1, 1, 1, 2 }, &[_]u8{ 1, 0, 1, 1, 1, 2 }, &[_]u8{ 1, 1, 0, 1, 1, 2 }, &[_]u8{ 1, 1, 1, 0, 1, 2 } };
pub const combos_covered3 = [_][]const u8{
    &[_]u8{ 2, 1, 1, 1, 0, 0 }, &[_]u8{ 2, 1, 1, 0, 1, 0 },
    &[_]u8{ 2, 1, 0, 1, 1, 0 }, &[_]u8{ 0, 0, 1, 1, 1, 2 },
    &[_]u8{ 0, 1, 0, 1, 1, 2 }, &[_]u8{ 0, 1, 1, 0, 1, 2 },
};

fn calcComboValue(w: u32, x2: u32, x3: u32, x4: u32, c3: u32, c4: u32) u64 {
    if (w > 0) return win_combo_value;
    if (x4 > 0) return 100000000;
    if (c4 > 1) return 10000000;
    if (x3 > 0 and c4 > 0) return 1000000;
    if (x3 > 1) return 100000;

    if (x3 == 1) {
        if (x2 == 3) return 40000;
        if (x2 == 2) return 38000;
        if (x2 == 1) return 35000;
        return 3450;
    }

    if (c4 == 1) {
        if (x2 == 3) return 4500;
        if (x2 == 2) return 4200;
        if (x2 == 1) return 4100;
        return 4050;
    }

    if (c3 == 1) {
        if (x2 == 3) return 3400;
        if (x2 == 2) return 3300;
        if (x2 == 1) return 3100;
    }

    if (c3 == 2) {
        if (x2 == 2) return 3000;
        if (x2 == 1) return 2900;
    }

    if (c3 == 3) {
        if (x2 == 1) return 2800;
    }

    if (x2 == 4) return 2700;
    if (x2 == 3) return 2500;
    if (x2 == 2) return 2000;
    if (x2 == 1) return 1000;

    return 0;
}

fn isSubArrayOf(arr: []const u8, inArr: []const u8) bool {
    const fCount = arr.len;
    const sCount = inArr.len;
    if (fCount < sCount) {
        return false;
    }

    var i: u32 = 0;
    while (i <= fCount - sCount) : (i += 1) {
        var k: u32 = 0;

        var j: u32 = 0;
        while (j < sCount) : (j += 1) {
            if (arr[i + j] == inArr[j]) {
                k += 1;
            } else {
                break;
            }
        }

        if (k == sCount) {
            return true;
        }
    }

    return false;
}

fn isAnyInArrays(arrayOfArray: []const []const u8, array: []const u8) bool {
    for (arrayOfArray) |x| {
        if (isSubArrayOf(array, x)) {
            return true;
        }
    }

    return false;
}

pub fn getComboValue4(combo0: []const u8, combo1: []const u8, combo2: []const u8, combo3: []const u8) u64 { // 4 directions
    var w: u32 = 0;
    var x2: u32 = 0;
    var x3: u32 = 0;
    var x4: u32 = 0;
    var c3: u32 = 0;
    var c4: u32 = 0;

    const combos = [_][]const u8{ combo0, combo1, combo2, combo3 };
    for (combos) |combo| {
        if (isAnyInArrays(&combos_win, combo)) {
            w += 1;
            continue;
        }

        if (isAnyInArrays(&combos_covered4, combo)) {
            c4 += 1;
            continue;
        }

        if (isAnyInArrays(&combos_covered3, combo)) {
            c3 += 1;
            continue;
        }

        if (isAnyInArrays(&combos_uncovered4, combo)) {
            x4 += 1;
            continue;
        }

        if (isAnyInArrays(&combos_uncovered3, combo)) {
            x3 += 1;
            continue;
        }

        if (isAnyInArrays(&combos_uncovered2, combo)) {
            x2 += 1;
        }
    }

    return calcComboValue(w, x2, x3, x4, c3, c4);
}
