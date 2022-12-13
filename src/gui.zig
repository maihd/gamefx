const raylib = @import("backends/raylib.zig");
const types = @import("types.zig");

// Types

const State = enum(u32) {
    normal = 0,
    focused,
    pressed,
    disabled,
};

const Control = enum(u32) {
    default,
    label,
    button,
    toggle,
    slider,
    progress_bar,
    check_box,
    combo_box,
    dropdown_box,
    text_box,
    value_box,
    spinner,
    list_view,
    color_picker,
    scroll_bar,
    status_bar
};

const ControlProperty = enum(u32) {
    border_color_normal,
    base_color_normal,
    text_color_normal,

    border_color_focused,
    base_color_focused,
    text_color_focused,

    border_color_pressed,
    base_color_pressed,
    text_color_pressed,

    border_color_disabled,
    base_color_disabled,
    text_color_disabled,

    border_width,
    text_padding,
    text_alignment,

    reserved,
};

// Global gui state control functions

pub fn enable() void {
    raylib.GuiEnable();
}

pub fn disable() void {
    raylib.GuiDisable();
}

pub fn isEnabled() bool {
    return getState() != .disabled;
}

pub fn lock() void {
    raylib.GuiLock();
}

pub fn unlock() void {
    raylib.GuiUnlock();
}

pub fn isLocked() bool {
    return raylib.IsLocked();
}

pub fn setState(state: State) void {
    raylib.GuiSetState(@enumToInt(state));
}

pub fn getState() State {
    return @intToEnum(State, raylib.GuiGetState());
}

// Styling

pub fn setFont(font: types.Font) void {
    raylib.SetFont(font);
}

pub fn getFont() types.Font {
    return raylib.GetFont();
}

pub fn setStyle(control: Control, property: ControlProperty, value: i32) void {
    raylib.GuiSetStyle(@enumToInt(control), @enumToInt(property), @as(c_int, value));
}

pub fn getStyle(control: Control, property: ControlProperty) i32 {
    return @as(i32, raylib.GuiSetStyle(@enumToInt(control), @enumToInt(property)));
}

// Basic controls set

pub fn Label(text: []const u8, bounds: types.Rect) void {
    raylib.GuiLabel(
        .{                              // bounds: raylib.Rectangle
            .x      = bounds[0],
            .y      = bounds[1],
            .width  = bounds[2],
            .height = bounds[3]
        }, 
        @ptrCast([*c]const u8, text)    // text: const c_char*
    );
}

pub fn Button(text: []const u8, bounds: types.Rect) bool {
    return raylib.GuiButton(
        .{                              // bounds: raylib.Rectangle
            .x      = bounds[0],
            .y      = bounds[1],
            .width  = bounds[2],
            .height = bounds[3]
        }, 
        @ptrCast([*c]const u8, text)    // text: const c_char*
    );
}

pub fn LabelButton(text: []const u8, bounds: types.Rect) bool {
    return raylib.GuiLabelButton(
        .{                              // bounds: raylib.Rectangle
            .x      = bounds[0],
            .y      = bounds[1],
            .width  = bounds[2],
            .height = bounds[3]
        }, 
        @ptrCast([*c]const u8, text)    // text: const c_char*
    );
}

pub fn Toggle(text: []const u8, bounds: types.Rect, active: bool) bool {
    return raylib.GuiToggle(
        .{                              // bounds: raylib.Rectangle
            .x      = bounds[0],
            .y      = bounds[1],
            .width  = bounds[2],
            .height = bounds[3]
        }, 
        @ptrCast([*c]const u8, text),   // text: const c_char*
        active                          // active: bool
    );
}

pub fn ToggleGroup(text: []const u8, bounds: types.Rect, active: i32) i32 {
    const current_active = raylib.GuiToggleGroup(
        .{                              // bounds: raylib.Rectangle
            .x      = bounds[0],
            .y      = bounds[1],
            .width  = bounds[2],
            .height = bounds[3]
        }, 
        @ptrCast([*c]const u8, text),   // text: const c_char*
        @as(c_int, active)              // active: c_int
    );

    return @as(i32, current_active);
}

pub fn CheckBox(text: []const u8, bounds: types.Rect, checked: bool) bool {
    return raylib.GuiCheckBox(
        .{                              // bounds: raylib.Rectangle
            .x      = bounds[0],
            .y      = bounds[1],
            .width  = bounds[2],
            .height = bounds[3]
        }, 
        @ptrCast([*c]const u8, text),   // text: const c_char*
        checked                         // checked: bool
    );
}

pub fn ComboBox(text: []const u8, bounds: types.Rect, active: i32) i32 {
    const current_active = raylib.GuiComboBox(
        .{                              // bounds: raylib.Rectangle
            .x      = bounds[0],
            .y      = bounds[1],
            .width  = bounds[2],
            .height = bounds[3]
        }, 
        @ptrCast([*c]const u8, text),   // text: const c_char*
        @as(c_int, active)              // active: c_int
    );

    return @as(i32, current_active);
}