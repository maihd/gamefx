const std = @import("std");
const gamefx = @import("gamefx");
const build_options = @import("build_options");

const assets_dir = build_options.assets_dir;

const Bullet = struct {
    position: gamefx.Vec2,
    velocity: gamefx.Vec2,
    rotation: f32,
    scale: gamefx.Vec2,
    texture: *const gamefx.Texture,
};

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

    const bullet_texture = try gamefx.assets.loadTexture("sprites/object_bullet.png");
    defer gamefx.assets.unloadTexture(bullet_texture);

    var player_position = gamefx.math.vec2(@as(f32, @divExact(config.width, 2)), @as(f32, @divExact(config.height, 2)));
    var player_rotation = @as(f32, 0);

    var player_shooting_timer: f32 = 0.0;
    const player_shooting_interval = 0.1;

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const leaked = gpa.deinit();
        if (leaked) {
            @panic("Game objects leaked!");
        }
    }

    const game_allocator = gpa.allocator();

    var bullets = std.ArrayList(Bullet).init(game_allocator);
    defer bullets.deinit();

    while (!gamefx.isClosing()) {
        // Moving player
        const delta_time = gamefx.getDeltaTime();

        var player_velocity = gamefx.math.vec2(0, 0);
        if (gamefx.input.isKeyDown(.up) or gamefx.input.isKeyDown(.w)) {
            player_velocity[1] -= 10;
        }
        
        if (gamefx.input.isKeyDown(.down) or gamefx.input.isKeyDown(.s)) {
            player_velocity[1] += 10;
        }
        
        if (gamefx.input.isKeyDown(.left) or gamefx.input.isKeyDown(.a)) {
            player_velocity[0] -= 10;
        } 
        
        if (gamefx.input.isKeyDown(.right) or gamefx.input.isKeyDown(.d)) {
            player_velocity[0] += 10;
        }

        if (!gamefx.math.isLengthZero2(player_velocity)) {
            player_rotation  = gamefx.math.angleDeg2(player_velocity);
            player_position += gamefx.math.vec2FromDegrees(player_rotation, 300 * gamefx.getDeltaTime());
        }

        if (gamefx.input.isMouseDown(.left)) {
            player_shooting_timer += delta_time;
            if (player_shooting_timer >= player_shooting_interval) {
                player_shooting_timer  = 0.0;

                const direction = gamefx.math.normalize2(gamefx.input.getMousePosition() - player_position);
                const angle = gamefx.math.angleRad2(direction);

                try bullets.append(.{
                    .position   = player_position + (direction * gamefx.math.vec2s(30.0)) + gamefx.math.vec2FromRadians(angle - std.math.pi * 0.25, 15),
                    .rotation   = gamefx.math.angleDeg2(direction),
                    .scale      = gamefx.math.vec2s(1.0),
                    .velocity   = direction * gamefx.math.vec2s(1000),
                    .texture    = bullet_texture
                });
                
                try bullets.append(.{
                    .position   = player_position + (direction * gamefx.math.vec2s(30.0)) + gamefx.math.vec2FromRadians(angle + std.math.pi * 0.25, 15),
                    .rotation   = gamefx.math.angleDeg2(direction),
                    .scale      = gamefx.math.vec2s(1.0),
                    .velocity   = direction * gamefx.math.vec2s(1000),
                    .texture    = bullet_texture
                });
            }
        } else {
            player_shooting_timer = player_shooting_interval;
        }

        for (bullets.items) |*bullet| {
            bullet.position += bullet.velocity * gamefx.math.vec2s(delta_time);
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

        for (bullets.items) |bullet| {
            gamefx.graphics.drawTexture(.{
                .texture    = bullet.texture, 
                .position   = bullet.position, 
                .rotation   = bullet.rotation,
                .scale      = bullet.scale, 
            });
        }
    }
}
