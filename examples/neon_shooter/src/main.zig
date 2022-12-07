const gamefx = @import("gamefx");
const build_options = @import("build_options");

const assets_dir = build_options.assets_dir;

pub fn main() !void {
    try gamefx.init(.{
        .title = "GameFX neon shooter",
        .width = 800,
        .height = 480
    });
    defer gamefx.deinit();

    try gamefx.assets.addSearchPath(assets_dir);
    defer gamefx.assets.removeSearchPath(assets_dir);

    const music_background = try gamefx.assets.loadMusic("audios/music_gameplay.mp3");
    defer gamefx.assets.unloadMusic(music_background);

    gamefx.audio.playMusic(music_background);
    defer gamefx.audio.stopMusic(music_background);

    const player_texture = try gamefx.assets.loadTexture("sprites/player_main.png");
    defer gamefx.assets.unloadTexture(player_texture);

    while (!gamefx.isClosing()) {
        gamefx.audio.updateMusic(music_background);

        try gamefx.graphics.newFrame();
        defer gamefx.graphics.endFrame();

        gamefx.graphics.clearBackground(gamefx.color32_raywhite);
        //gamefx.graphics.drawText("Neon Shooter Game!", .{ 310, 220 }, 20, gamefx.color32_lightgray);
        gamefx.graphics.drawTexture(player_texture, .{ 310, 220 }, gamefx.color32_white);
    }
}
