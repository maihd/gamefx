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

    var player_position = gamefx.math.vec2(@as(f32, @divExact(config.width, 2)), @as(f32, @divExact(config.height, 2)));
    var player_rotation = @as(f32, 0);

    while (!gamefx.isClosing()) {
        // Moving player
        var player_velocity = gamefx.math.vec2(0, 0);
        if (gamefx.input.isKeyDown(.up)) {
            player_velocity[1] -= 10;
        }
        
        if (gamefx.input.isKeyDown(.down)) {
            player_velocity[1] += 10;
        }
        
        if (gamefx.input.isKeyDown(.left)) {
            player_velocity[0] -= 10;
        } 
        
        if (gamefx.input.isKeyDown(.right)) {
            player_velocity[0] += 10;
        }

        if (gamefx.math.lengthSq2(player_velocity)[0] > 0) {
            player_rotation  = gamefx.math.angleDeg2(player_velocity);
            player_position += gamefx.math.fromAngleLengthDeg2(player_rotation, 300 * gamefx.getDeltaTime());
        }

        // Continuous playing music
        gamefx.audio.updateMusic(music_background);

        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();

        gamefx.graphics.clearBackground(gamefx.color32_black);
        gamefx.graphics.drawTexture(.{
            .texture    = player_texture, 
            .position   = player_position, 
            .rotation   = player_rotation, 
            .scale      = gamefx.math.vec2s(1.0), 
        });
    }
}
