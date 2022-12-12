const gamefx = @import("gamefx");
const build_options = @import("build_options");

const assets_dir = build_options.assets_dir;

pub fn main() !void {
    const config = gamefx.Config{
        .title = "GameFX neon shooter",
        .width = 800,
        .height = 480
    };

    try gamefx.init(config);
    defer gamefx.deinit();

    try gamefx.assets.addSearchPath(assets_dir);
    defer gamefx.assets.removeSearchPath(assets_dir);

    const music_background = try gamefx.assets.loadMusic("audios/music_gameplay.mp3");
    defer gamefx.assets.unloadMusic(music_background);

    gamefx.audio.playMusic(music_background);
    defer gamefx.audio.stopMusic(music_background);

    const player_texture = try gamefx.assets.loadTexture("sprites/player_main.png");
    defer gamefx.assets.unloadTexture(player_texture);

    var player_position = gamefx.f32x2{ @as(f32, @divExact(config.width, 2)), @as(f32, @divExact(config.height, 2)) };
    var player_rotation = @as(f32, 0);

    while (!gamefx.isClosing()) {
        // Moving player
        if (gamefx.input.isKeyDown(.up)) {
            player_rotation = 270;
        } else if (gamefx.input.isKeyDown(.down)) {
            player_rotation = 90;
        } else if (gamefx.input.isKeyDown(.left)) {
            player_rotation = 0;
        } else if (gamefx.input.isKeyDown(.right)) {
            player_rotation = 180;
        }

        // Continuous playing music
        gamefx.audio.updateMusic(music_background);

        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();

        gamefx.graphics.clearBackground(gamefx.color32_raywhite);
        gamefx.graphics.drawTexture(.{
            .texture    = player_texture, 
            .position   = player_position, 
            .rotation   = player_rotation, 
            .scale      = .{ 1.0, 1.0 }, 
            .tint       = gamefx.color32_black
        });
    }
}
