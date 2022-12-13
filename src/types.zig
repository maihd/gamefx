const zmath = @import("zmath");
const raylib = @import("backends/raylib.zig");

// Math types

pub const Vec           = zmath.Vec;
pub const Mat           = zmath.Mat;
pub const Quat          = zmath.Quat;

// Graphics types

pub const Rect          = Vec;
pub const BoundingBox   = raylib.BoundingBox;

pub const Color         = Vec;
pub const Color32       = [4]u8;

pub const Font          = raylib.Font;
pub const GlyphInfo     = raylib.GlyphInfo;

pub const Image         = raylib.Image;
pub const Texture       = raylib.Texture;
pub const NPatchInfo    = raylib.NPatchInfo;

pub const Mesh          = raylib.Mesh;
//pub const Model         = raylib.Model;
//pub const ModelAnimation = raylib.ModelAnimation;

pub const Camera        = raylib.Camera;
pub const Camera2D      = raylib.Camera2D;

pub const Shader        = raylib.Shader;
pub const Material      = raylib.Material;
pub const MaterialMap   = raylib.MaterialMap;

pub const RenderTexture = raylib.RenderTexture;

// Audio types

pub const Wave          = raylib.Wave;
pub const Music         = raylib.Music;
pub const Sound         = raylib.Sound;
pub const AudioStream   = raylib.AudioStream;

// Input types

pub const Key       = enum(c_int) {
    none            = 0,        // Key: NULL, used for no key pressed

    // Alphanumeric keys
    apostrophe      = 39,       // Key: '
    comma           = 44,       // Key: ,
    minus           = 45,       // Key: -
    period          = 46,       // Key: .
    slash           = 47,       // Key: /
    zero            = 48,       // Key: 0
    num_1           = 49,       // Key: 1
    num_2           = 50,       // Key: 2
    num_3           = 51,       // Key: 3
    num_4           = 52,       // Key: 4
    num_5           = 53,       // Key: 5
    num_6           = 54,       // Key: 6
    num_7           = 55,       // Key: 7
    num_8           = 56,       // Key: 8
    num_9           = 57,       // Key: 9
    semicolon       = 59,       // Key: ;
    equal           = 61,       // Key: =
    a               = 65,       // Key: A | a
    b               = 66,       // Key: B | b
    c               = 67,       // Key: C | c
    d               = 68,       // Key: D | d
    e               = 69,       // Key: E | e
    f               = 70,       // Key: F | f
    g               = 71,       // Key: G | g
    h               = 72,       // Key: H | h
    i               = 73,       // Key: I | i
    j               = 74,       // Key: J | j
    k               = 75,       // Key: K | k
    l               = 76,       // Key: L | l
    m               = 77,       // Key: M | m
    n               = 78,       // Key: N | n
    o               = 79,       // Key: O | o
    p               = 80,       // Key: P | p
    q               = 81,       // Key: Q | q
    r               = 82,       // Key: R | r
    s               = 83,       // Key: S | s
    t               = 84,       // Key: T | t
    u               = 85,       // Key: U | u
    v               = 86,       // Key: V | v
    w               = 87,       // Key: W | w
    x               = 88,       // Key: X | x
    y               = 89,       // Key: Y | y
    z               = 90,       // Key: Z | z
    left_bracket    = 91,       // Key: [
    backslash       = 92,       // Key: '\'
    right_bracket   = 93,       // Key: ]
    grave           = 96,       // Key: `

    // Function keys
    space           = 32,       // Key: Space
    escape          = 256,      // Key: Esc
    enter           = 257,      // Key: Enter
    tab             = 258,      // Key: Tab
    backspace       = 259,      // Key: Backspace
    insert          = 260,      // Key: Ins
    delete          = 261,      // Key: Del
    right           = 262,      // Key: Cursor right
    left            = 263,      // Key: Cursor left
    down            = 264,      // Key: Cursor down
    up              = 265,      // Key: Cursor up
    page_up         = 266,      // Key: Page up
    page_down       = 267,      // Key: Page down
    home            = 268,      // Key: Home
    end             = 269,      // Key: End
    caps_lock       = 280,      // Key: Caps lock
    scroll_lock     = 281,      // Key: Scroll down
    num_lock        = 282,      // Key: Num lock
    print_screen    = 283,      // Key: Print screen
    pause           = 284,      // Key: Pause
    f1              = 290,      // Key: F1
    f2              = 291,      // Key: F2
    f3              = 292,      // Key: F3
    f4              = 293,      // Key: F4
    f5              = 294,      // Key: F5
    f6              = 295,      // Key: F6
    f7              = 296,      // Key: F7
    f8              = 297,      // Key: F8
    f9              = 298,      // Key: F9
    f10             = 299,      // Key: F10
    f11             = 300,      // Key: F11
    f12             = 301,      // Key: F12
    left_shift      = 340,      // Key: Shift left
    left_control    = 341,      // Key: Control left
    left_alt        = 342,      // Key: Alt left
    left_super      = 343,      // Key: Super left
    right_shift     = 344,      // Key: Shift right
    right_control   = 345,      // Key: Control right
    right_alt       = 346,      // Key: Alt right
    right_super     = 347,      // Key: Super right
    menu            = 348,      // Key: menu

    // Keypad keys
    keypad_0            = 320,      // Key: Keypad 0
    keypad_1            = 321,      // Key: Keypad 1
    keypad_2            = 322,      // Key: Keypad 2
    keypad_3            = 323,      // Key: Keypad 3
    keypad_4            = 324,      // Key: Keypad 4
    keypad_5            = 325,      // Key: Keypad 5
    keypad_6            = 326,      // Key: Keypad 6
    keypad_7            = 327,      // Key: Keypad 7
    keypad_8            = 328,      // Key: Keypad 8
    keypad_9            = 329,      // Key: Keypad 9
    keypad_DECIMAL      = 330,      // Key: Keypad .
    keypad_DIVIDE       = 331,      // Key: Keypad /
    keypad_MULTIPLY     = 332,      // Key: Keypad *
    keypad_SUBTRACT     = 333,      // Key: Keypad -
    keypad_ADD          = 334,      // Key: Keypad +
    keypad_ENTER        = 335,      // Key: Keypad Enter
    keypad_EQUAL        = 336,      // Key: Keypad =

    // Android key buttons
    //button_back            = 4,        // Key: Android back button
    //button_menu            = 82,       // Key: Android menu button
    //button_volume_up       = 24,       // Key: Android volume up button
    //button_volume_down     = 25        // Key: Android volume down button
};

pub const MouseButton = enum(c_int) {
    left    = 0,    // Mouse button left
    right   = 1,    // Mouse button right
    middle  = 2,    // Mouse button middle (pressed wheel)
    side    = 3,    // Mouse button side (advanced mouse device)
    extra   = 4,    // Mouse button extra (advanced mouse device)
    forward = 5,    // Mouse button forward (advanced mouse device)
    back    = 6,    // Mouse button back (advanced mouse device)
};

pub const MouseCursor = enum(c_int) {
    default       = 0,     // Default pointer shape
    arrow         = 1,     // Arrow shape
    ibeam         = 2,     // Text writing cursor shape
    crosshair     = 3,     // Cross shape
    pointing_hand = 4,     // Pointing hand cursor
    resize_ew     = 5,     // Horizontal resize/move arrow shape
    resize_ns     = 6,     // Vertical resize/move arrow shape
    resize_nwse   = 7,     // Top-left to bottom-right diagonal resize/move arrow shape
    resize_nesw   = 8,     // The top-right to bottom-left diagonal resize/move arrow shape
    resize_all    = 9,     // The omni-directional resize/move cursor shape
    not_allowed   = 10     // The operation-not-allowed shape
};