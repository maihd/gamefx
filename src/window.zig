const raylib = @import("backends/raylib.zig");

var is_init = false;

pub const Config = struct {
    title: []const u8,
    width: i32,
    height: i32,
    framerate: i32 = 60
};

pub fn init(config: Config) !void {
    if (config.title.len == 0) {
        return error.TitleInvalid;
    }

    if (config.width <= 0) {
        return error.WidthInvalid;
    }

    if (config.height <= 0) {
        return error.HeightInvalid;
    }

    if (config.framerate <= 0) {
        return error.FramerateInvalid;
    }

    raylib.InitWindow(config.width, config.height, @ptrCast([*c]const u8, config.title));
    raylib.SetTargetFPS(config.framerate);

    is_init = true;
}

pub fn deinit() void {
    raylib.CloseWindow();
    is_init = false;
}

pub fn isInit() bool {
    return is_init;
}

pub fn isClosing() bool {
    return raylib.WindowShouldClose();
}