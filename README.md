MaiHD's Game Framework for small game development
-------------------------------------------------
WIP, API maybe changed!

> **_NOTE:_** I found making a game framework in the first attempt was too big, I havenot release a game yet. So this project now is for learning purpose only. So I donot often work in this project. I found MonoGame is more suit for making mobile game, yolo game development for fast release indie game. Zig for game engine and Beef for scripting (wasi in Zig, build Beef to wasm) will be my long-term target.

Features
--------
- Focus on mobile gamedev: lightweight, fast, low-power consumption.
- Focus on 2D gamedev: Pixels, casual graphics. Auto background playing.
- Zig-based gamedev: rich libraries, easy custom backends, fast machine code generation, cross building.
- Multi-backends: raylib, zig-gamedev.
- Graphics: 2D, 3D, geometry drawing, vector, text, spine animation (wip).
- Audios: 2D, 2D.
- Assets: load from file system, caching, load from package (wip).
- Math: zig's @Vector for fast computing, easy programming, use zig-gamedev's zmath as backend.
- GUI: raygui for in-game immediate-mode gui, zgui (wip) for editor.
- Tilemap: tile texture drawing, tilemesh drawing, loading ldtk and present with native tilemap data structures (planning).

Acknownledge
------------
- [raysan5](https://github.com/raysan5) and his [Raylib](https://github.com/raysan5/raylib).
- [michal-z](https://github.com/michal-z) and his [zig-gamedev](https://github.com/michal-z/zig-gamedev).
- Zig author and community.